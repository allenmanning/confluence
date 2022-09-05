package.path = package.path .. ';../?.lua'
lu = require('luaunit')

confluence = require('confluence-overrides')

TestModules = {}
function TestModules:testCaptionedImageExists()
  lu.assertNotIsNil(confluence.CaptionedImageConfluence)
end

TestCaptionedImage = {}
function TestCaptionedImage:testCanRenderImage()
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

os.exit(lu.LuaUnit.run())