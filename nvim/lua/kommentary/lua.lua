local kommentary = require('kommentary.config')

kommentary.configure_language("rust", {
    use_consistent_indentation = true,
    ignore_whitespace = true,
    single_line_comment_string = "//",
    multi_line_comment_strings = {"/*", "*/"},
})
kommentary.configure_language("cs", {
    use_consistent_indentation = true,
    ignore_whitespace = true,
    single_line_comment_string = "//",
    multi_line_comment_strings = {"/*", "*/"},
})
kommentary.configure_language("js", {
    use_consistent_indentation = true,
    ignore_whitespace = true,
    single_line_comment_string = "//",
    multi_line_comment_strings = {"/*", "*/"},
})
kommentary.configure_language("jsx", {
    use_consistent_indentation = true,
    ignore_whitespace = true,
    single_line_comment_string = "//",
    multi_line_comment_strings = {"/*", "*/"},
})
kommentary.configure_language("html", {
    use_consistent_indentation = true,
    ignore_whitespace = true,
    multi_line_comment_strings = {"<!-- ", " -->"},
})
kommentary.configure_language("css", {
    use_consistent_indentation = true,
    ignore_whitespace = true,
    multi_line_comment_strings = {"/*", "*/"},
})
