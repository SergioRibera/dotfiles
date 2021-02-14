if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility
    
    set guifont=Iconsolata\ Slab:h11

    "FVimCursorSmoothMove v:true
    "FVimCursorSmoothBlink v:true

    " Background composition
    FVimBackgroundComposition 'acrylic'   " 'none', 'transparent', 'blur' or 'acrylic'
    FVimBackgroundOpacity 0.85            " value between 0 and 1, default bg opacity.
    FVimBackgroundAltOpacity 0.85         " value between 0 and 1, non-default bg opacity.
    "FVimBackgroundImage 'C:/foobar.png'   " background image
    "FVimBackgroundImageVAlign 'center'    " vertial position, 'top', 'center' or 'bottom'
    "FVimBackgroundImageHAlign 'center'    " horizontal position, 'left', 'center' or 'right'
    "FVimBackgroundImageStretch 'fill'     " 'none', 'fill', 'uniform', 'uniformfill'
    "FVimBackgroundImageOpacity 0.85       " value between 0 and 1, bg image opacity

    " Title bar tweaks
    "FVimCustomTitleBar v:true             " themed with colorscheme

    " Debug UI overlay
    "FVimDrawFPS v:true

    " Font tweaks
    "FVimFontAntialias v:true
    "FVimFontAutohint v:true
    "FVimFontHintLevel 'full'
    "FVimFontLigature v:true
    "FVimFontLineHeight '+1.0' " can be 'default', '14.0', '-1.0' etc.
    "FVimFontSubpixel v:true
    "FVimFontNoBuiltInSymbols v:true " Disable built-in Nerd font symbols

    " Try to snap the fonts to the pixels, reduces blur
    " in some situations (e.g. 100% DPI).
    "FVimFontAutoSnap v:true

    " Font weight tuning, possible valuaes are 100..900
    FVimFontNormalWeight 400
    FVimFontBoldWeight 700

    " Font debugging -- draw bounds around each glyph
    "FVimFontDrawBounds v:true

    " UI options (all default to v:false)
    "FVimUIMultiGrid v:false     " per-window grid system -- work in progress
    "FVimUIPopupMenu v:true      " external popup menu
    "FVimUITabLine v:false       " external tabline -- not implemented
    "FVimUICmdLine v:false       " external cmdline -- not implemented
    "FVimUIWildMenu v:false      " external wildmenu -- not implemented
    "FVimUIMessages v:false      " external messages -- not implemented
    "FVimUITermColors v:true    " not implemented
    "FVimUIHlState v:false       " not implemented

    " Detach from a remote session without killing the server
    " If this command is executed on a standalone instance,
    " the embedded process will be terminated anyway.
    FVimDetach
endif
