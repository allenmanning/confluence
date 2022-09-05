package.path = package.path .. ';../?.lua'
lu = require('luaunit')

confluence = require('confluence-overrides')

TestModules = {}
function TestModules:testCaptionedImageExists()
  lu.assertNotIsNil(confluence.CaptionedImageConfluence)
end

TestCaptionedImage = {}
function TestCaptionedImage:testWithAllAttributes()
  local expected = [[<ac:image
    ac:align=""
    ac:layout=""
    ac:alt="fake-title"
    ac:src="fake-source">
        <ri:url ri:value="fake-source" />
        <ac:caption>
            <p>fake-caption</p>
        </ac:caption>
    </ac:image>]]
  local source = 'fake-source'
  local title = 'fake-title'
  local caption = 'fake-caption'
  local actual = confluence.CaptionedImageConfluence(source, title, caption)

  lu.assertEquals(actual, expected)
end

TestCodeBlockConfluence = {}
function TestCodeBlockConfluence:testWithAllAttributes()
  local expected = [[<ac:structured-macro
      ac:name="code"
      ac:schema-version="1"
      ac:macro-id="1d1a2d13-0179-4d8f-b448-b28dfaceea4a">
        <ac:parameter ac:name="language">fake-class</ac:parameter>
        <ac:plain-text-body>
          <![CDATA[fake-codeValue{doubleBracket}>
        </ac:plain-text-body>
    </ac:structured-macro>]]
  local codeValue = 'fake-codeValue'
  local attributes = {
    class = 'fake-class'
  }
  expected = confluence.interpolate{expected, doubleBracket = ']]'}
  local actual = confluence.CodeBlockConfluence(codeValue, attributes)

  lu.assertEquals(actual, expected)
end

os.exit(lu.LuaUnit.run())