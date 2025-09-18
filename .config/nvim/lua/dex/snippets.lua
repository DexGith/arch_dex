local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("lua", {
    s("pr", t("print()")),
    s("req", t({ "local mod = require('')", "" })),
})

ls.add_snippets("python", {
    s("main", t({ 'if __name__ == "__main__":', "\t" })),
})
