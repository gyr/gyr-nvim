if vim.fn.isdirectory(vim.fn.stdpath("data") .. "/site/pack/core/opt/vimwiki") == 1 then
    vim.g.vimwiki_list = {
        {
            path = "~/.gyr.d/vimwiki/",
            path_html = "~/.gyr.d/public_html/",
            nested_syntaxes = {
                python = "python",
                ["c++"] = "cpp",
                sh = "sh",
                perl = "perl",
                conf = "conf",
                fstab = "fstab",
                deb = "debsources",
                resolv = "resolv",
                xml = "xml",
            },
        },
    }
    vim.g.vimwiki_hl_headers = 1
    vim.g.vimwiki_hl_cb_checked = 1
    vim.g.vimwiki_fold_lists = 1
    vim.g.vimwiki_html_header_numbering = 1
end
