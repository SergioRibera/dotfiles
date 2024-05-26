let
  _cfg = name: {
      name = "Default ${name}";
      type = "gdb";
      request = name;
    };
  cfg = [(_cfg "launch")];
in {
  enable = true;
  extensions = {
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
  };
  signs.dapBreakpoint = {
    text = "●";
    texthl = "Debug";
  };
  adapters = {
    # C, C++, Rust
    executables.gdb = {
      command = "gdb";
      args = [ "-i" "dap" ];
    };
  };

  configurations = {
    rust = cfg;
    c = cfg;
    cpp = cfg;
  };
}
