{ pkgs, lib, ... }: let
  lsp_internal = name: bin: let
    pkg = pkgs.${name};
  in {
    ${name} = {
      command = "${pkg}/bin/${bin}";
      args = ["--stdio"];
    };
  };
  lsp_pkg = name:
    (lsp_internal name name)
    // {
      __functor = self: bin: lsp_internal name bin;
    };
in {
  lsp = (lib.removeAttrs ({
    rust-analyzer = {
      binary.path_lookup = true;
      initialization_options = {
        cachePriming = false;
        check.features = "all";
        cargo = {
          features = "all";
          allTargets = false;
          buildScripts = true;
        };
        diagnostics = {
          experimental = true;
        };
        imports = {
          prefix = "self";
          granularity = { group = "module"; };
        };
      };
    };
    nu = {
      command = "${pkgs.nushell}/bin/nu";
      args = ["--lsp"];
    };
  }
    // (lsp_pkg "vue-language-server")
    // (lsp_pkg "typescript-language-server")
    // (lsp_pkg "astro-language-server" "astro-ls")
    // (lsp_pkg "dockerfile-language-server" "docker-langserver")
    // (lsp_pkg "vscode-langservers-extracted" "vscode-json-language-server")
    # // (lsp_pkg "vscode-langservers-extracted" "vscode-css-language-server")
    // (lsp_pkg "vscode-langservers-extracted" "vscode-html-language-server")
    // (lsp_pkg "vscode-langservers-extracted" "vscode-markdown-language-server")
    // (lsp_pkg "vscode-langservers-extracted" "vscode-eslint-language-server")
  )
  ["__functor"]);
}
