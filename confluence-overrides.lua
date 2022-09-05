-- Confluence Storage Format for Pandoc
-- https://confluence.atlassian.com/doc/confluence-storage-format-790796544.html
-- https://pandoc.org/MANUAL.html#custom-readers-and-writers
local function escape(s, in_attribute)
  return s:gsub("[<>&\"']",
          function(x)
            if x == '<' then
              return '&lt;'
            elseif x == '>' then
              return '&gt;'
            elseif x == '&' then
              return '&amp;'
            elseif in_attribute and x == '"' then
              return '&quot;'
            elseif in_attribute and x == "'" then
              return '&#39;'
            else
              return x
            end
          end)
end

local function isEmpty(s)
  return s == nil or s == ''
end

-- from http://lua-users.org/wiki/StringInterpolation
local interpolate = function(str, vars)
  -- Allow replace_vars{str, vars} syntax as well as replace_vars(str, {vars})
  if not vars then
    vars = str
    str = vars[1]
  end
  return (string.gsub(str, "({([^}]+)})",
          function(whole, i)
            return vars[i] or whole
          end))
end

function CaptionedImageConfluence(source, title, caption)
  local CAPTION_SNIPPET = [[<ac:caption>
            <p>{caption}</p>
        </ac:caption>]]

  local IMAGE_SNIPPET = [[<ac:image
    ac:align="{align}"
    ac:layout="{layout}"
    ac:alt="{alt}"
    ac:src="{source}">
        <ri:url ri:value="{source}" />
        {caption}
    </ac:image>]]

  local sourceValue = escape(source, true)
  local titleValue = escape(title, true)
  local captionValue = escape(caption)
  if not isEmpty(captionValue) then
    captionValue =
    interpolate {CAPTION_SNIPPET, caption = captionValue}
  end

  return interpolate {
    IMAGE_SNIPPET,
    source = sourceValue,
    align = '',
    layout = '',
    alt = titleValue,
    caption = captionValue}
end

function CodeBlockConfluence(codeValue, attributes)
  local languageValue = attributes and attributes.class or ''
  local CODE_SNIPPET = [[<ac:structured-macro
      ac:name="code"
      ac:schema-version="1"
      ac:macro-id="1d1a2d13-0179-4d8f-b448-b28dfaceea4a">
        <ac:parameter ac:name="language">{languageValue}</ac:parameter>
        <ac:plain-text-body>
          <![CDATA[{codeValue}{doubleBraket}>
        </ac:plain-text-body>
    </ac:structured-macro>]]

  return interpolate {
    CODE_SNIPPET,
    languageValue = languageValue,
    codeValue = codeValue,
    doubleBraket = ']]'
  }
end

return {
  CaptionedImageConfluence = CaptionedImageConfluence,
  CodeBlockConfluence = CodeBlockConfluence,
  escape = escape,
  interpolate = interpolate
}