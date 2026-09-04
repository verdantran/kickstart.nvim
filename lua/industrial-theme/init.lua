local p = require 'industrial-theme.palette'

local M = {}

M.config = {
  transparent = false,
  italic_comments = false,
  bold_keywords = true,
  -- Mimics the phosphor bloom of the art by bolding the brightest glyph roles.
  glow = true,
  -- Bloom behind keyword tokens, 0..1. 0 disables. Ignored when transparent.
  keyword_halo = 0.06,
  dim_inactive = true,
}

-- Alpha-composites `fg` over `bg`, both '#rrggbb'.
local function blend(fg, bg, alpha)
  local function parts(h)
    local n = tonumber(h:sub(2), 16)
    return math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256
  end
  local r1, g1, b1 = parts(fg)
  local r2, g2, b2 = parts(bg)
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return ('#%02x%02x%02x'):format(mix(r1, r2), mix(g1, g2), mix(b1, b2))
end

local function groups()
  local cfg = M.config
  local bg = cfg.transparent and 'NONE' or p.bg
  local bg_float = cfg.transparent and 'NONE' or p.bg_alt
  local glow = cfg.glow
  local ci = cfg.italic_comments

  local function halo(accent)
    if cfg.transparent or cfg.keyword_halo <= 0 then
      return nil
    end
    return blend(accent, p.bg, cfg.keyword_halo)
  end
  local kw, kw_err = halo(p.orange), halo(p.red)

  return {
    -- Editor
    Normal = { fg = p.fg, bg = bg },
    NormalNC = { fg = p.fg, bg = cfg.dim_inactive and not cfg.transparent and p.void or bg },
    NormalFloat = { fg = p.fg, bg = bg_float },
    FloatBorder = { fg = p.border, bg = bg_float },
    FloatTitle = { fg = p.orange, bg = bg_float, bold = true },
    Cursor = { fg = p.bg, bg = p.fg_bright },
    lCursor = { link = 'Cursor' },
    CursorLine = { bg = p.bg_hl },
    CursorColumn = { link = 'CursorLine' },
    ColorColumn = { bg = p.bg_alt },
    CursorLineNr = { fg = p.orange, bold = true },
    LineNr = { fg = p.line_nr },
    LineNrAbove = { link = 'LineNr' },
    LineNrBelow = { link = 'LineNr' },
    SignColumn = { bg = bg },
    FoldColumn = { fg = p.line_nr, bg = bg },
    Folded = { fg = p.grey_br, bg = p.bg_glow },
    Visual = { bg = p.bg_sel },
    VisualNOS = { link = 'Visual' },
    Search = { fg = p.bg, bg = p.blue_soft },
    IncSearch = { fg = p.bg, bg = p.orange_br, bold = true },
    CurSearch = { link = 'IncSearch' },
    Substitute = { fg = p.bg, bg = p.red },
    MatchParen = { fg = p.orange_br, bold = true, underline = true },
    Whitespace = { fg = p.bg_sel },
    NonText = { fg = p.bg_sel },
    SpecialKey = { fg = p.grey },
    EndOfBuffer = { fg = p.bg },
    Conceal = { fg = p.grey },
    Directory = { fg = p.blue_lit },
    Title = { fg = p.fg_bright, bold = true },
    ErrorMsg = { fg = p.red, bold = true },
    WarningMsg = { fg = p.orange },
    MoreMsg = { fg = p.blue_soft },
    ModeMsg = { fg = p.fg_bright, bold = true },
    Question = { fg = p.blue_lit },
    MsgArea = { fg = p.fg },
    MsgSeparator = { fg = p.border, bg = p.bg_alt },
    WinSeparator = { fg = p.border, bg = bg },
    VertSplit = { link = 'WinSeparator' },
    WinBar = { fg = p.fg_dim, bg = bg, bold = true },
    WinBarNC = { fg = p.grey, bg = bg },

    StatusLine = { fg = p.fg_dim, bg = p.bg_alt },
    StatusLineNC = { fg = p.grey, bg = p.void },
    TabLine = { fg = p.grey_br, bg = p.bg_alt },
    TabLineFill = { bg = p.void },
    TabLineSel = { fg = p.bg, bg = p.orange, bold = true },

    Pmenu = { fg = p.fg_dim, bg = p.bg_alt },
    PmenuSel = { fg = p.fg_bright, bg = p.bg_sel, bold = true },
    PmenuKind = { fg = p.violet, bg = p.bg_alt },
    PmenuKindSel = { fg = p.violet, bg = p.bg_sel },
    PmenuExtra = { fg = p.grey, bg = p.bg_alt },
    PmenuExtraSel = { fg = p.grey_br, bg = p.bg_sel },
    PmenuSbar = { bg = p.bg_glow },
    PmenuThumb = { bg = p.border },
    PmenuMatch = { fg = p.orange_br, bg = p.bg_alt, bold = true },
    PmenuMatchSel = { fg = p.orange_br, bg = p.bg_sel, bold = true },
    WildMenu = { link = 'PmenuSel' },

    QuickFixLine = { bg = p.bg_sel, bold = true },
    SpellBad = { sp = p.red, undercurl = true },
    SpellCap = { sp = p.orange, undercurl = true },
    SpellLocal = { sp = p.blue_lit, undercurl = true },
    SpellRare = { sp = p.violet, undercurl = true },

    -- Legacy syntax
    Comment = { fg = p.grey, italic = ci },
    Constant = { fg = p.orange_br },
    String = { fg = p.blue_soft },
    Character = { fg = p.blue_soft },
    Number = { fg = p.sand },
    Boolean = { fg = p.orange_br, bold = glow },
    Float = { fg = p.sand },
    Identifier = { fg = p.fg },
    Function = { fg = p.fg_bright, bold = glow },
    Statement = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    Conditional = { link = 'Statement' },
    Repeat = { link = 'Statement' },
    Label = { fg = p.orange_deep },
    Operator = { fg = p.grey_br },
    Keyword = { link = 'Statement' },
    Exception = { fg = p.red, bg = kw_err },
    PreProc = { fg = p.violet },
    Include = { link = 'Statement' },
    Define = { fg = p.violet },
    Macro = { fg = p.violet },
    PreCondit = { fg = p.violet },
    Type = { fg = p.violet },
    StorageClass = { fg = p.orange },
    Structure = { fg = p.violet },
    Typedef = { fg = p.violet },
    Special = { fg = p.orange_br },
    SpecialChar = { fg = p.orange_br },
    Tag = { fg = p.orange },
    Delimiter = { fg = p.grey_br },
    SpecialComment = { fg = p.grey_br, italic = ci },
    Debug = { fg = p.red },
    Underlined = { underline = true },
    Ignore = { fg = p.grey },
    Error = { fg = p.red, bold = true },
    Todo = { fg = p.bg, bg = p.orange, bold = true },

    -- Treesitter
    ['@variable'] = { fg = p.fg },
    ['@variable.builtin'] = { fg = p.orange, italic = true },
    ['@variable.parameter'] = { fg = p.blue_pale, italic = true },
    ['@variable.member'] = { fg = p.blue_soft },
    ['@constant'] = { fg = p.orange_br },
    ['@constant.builtin'] = { fg = p.orange_br, bold = glow },
    ['@constant.macro'] = { fg = p.violet },
    ['@module'] = { fg = p.blue_pale },
    ['@module.builtin'] = { fg = p.blue_pale, bold = glow },
    ['@label'] = { fg = p.orange_deep },
    ['@string'] = { fg = p.blue_soft },
    ['@string.documentation'] = { fg = p.grey_br, italic = ci },
    ['@string.regexp'] = { fg = p.cyan },
    ['@string.escape'] = { fg = p.orange_br, bold = glow },
    ['@string.special'] = { fg = p.orange_br },
    ['@string.special.url'] = { fg = p.blue_lit, underline = true },
    ['@character'] = { fg = p.blue_soft },
    ['@character.special'] = { fg = p.orange_br },
    ['@boolean'] = { fg = p.orange_br, bold = glow },
    ['@number'] = { fg = p.sand },
    ['@number.float'] = { fg = p.sand },
    ['@type'] = { fg = p.violet },
    ['@type.builtin'] = { fg = p.violet_dim },
    ['@type.definition'] = { fg = p.violet, bold = glow },
    ['@attribute'] = { fg = p.violet_dim },
    ['@property'] = { fg = p.blue_soft },
    ['@function'] = { fg = p.fg_bright, bold = glow },
    ['@function.builtin'] = { fg = p.cyan },
    ['@function.call'] = { fg = p.fg_bright },
    ['@function.macro'] = { fg = p.violet },
    ['@function.method'] = { fg = p.fg_bright, bold = glow },
    ['@function.method.call'] = { fg = p.fg_bright },
    ['@constructor'] = { fg = p.violet },
    ['@operator'] = { fg = p.grey_br },
    ['@keyword'] = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    ['@keyword.function'] = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    ['@keyword.operator'] = { fg = p.orange, bg = kw },
    ['@keyword.import'] = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    ['@keyword.exception'] = { fg = p.red, bg = kw_err },
    ['@keyword.return'] = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    ['@keyword.conditional'] = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    ['@keyword.repeat'] = { fg = p.orange, bg = kw, bold = cfg.bold_keywords },
    ['@punctuation.delimiter'] = { fg = p.grey_br },
    ['@punctuation.bracket'] = { fg = p.grey_br },
    ['@punctuation.special'] = { fg = p.orange_deep },
    ['@comment'] = { fg = p.grey, italic = ci },
    ['@comment.error'] = { fg = p.bg, bg = p.red, bold = true },
    ['@comment.warning'] = { fg = p.bg, bg = p.orange, bold = true },
    ['@comment.todo'] = { fg = p.bg, bg = p.blue_lit, bold = true },
    ['@comment.note'] = { fg = p.bg, bg = p.cyan, bold = true },
    ['@markup.strong'] = { fg = p.fg_bright, bold = true },
    ['@markup.italic'] = { italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { underline = true },
    ['@markup.heading'] = { fg = p.orange, bold = true },
    ['@markup.heading.1'] = { fg = p.orange, bold = true },
    ['@markup.heading.2'] = { fg = p.orange_br, bold = true },
    ['@markup.heading.3'] = { fg = p.sand, bold = true },
    ['@markup.heading.4'] = { fg = p.fg_bright, bold = true },
    ['@markup.heading.5'] = { fg = p.blue_pale, bold = true },
    ['@markup.heading.6'] = { fg = p.blue_soft, bold = true },
    ['@markup.quote'] = { fg = p.grey_br, italic = true },
    ['@markup.math'] = { fg = p.cyan },
    ['@markup.link'] = { fg = p.blue_lit },
    ['@markup.link.label'] = { fg = p.violet },
    ['@markup.link.url'] = { fg = p.blue_lit, underline = true },
    ['@markup.raw'] = { fg = p.blue_soft },
    ['@markup.raw.block'] = { fg = p.blue_soft, bg = p.bg_alt },
    ['@markup.list'] = { fg = p.orange },
    ['@markup.list.checked'] = { fg = p.blue_lit },
    ['@markup.list.unchecked'] = { fg = p.grey_br },
    ['@tag'] = { fg = p.orange },
    ['@tag.builtin'] = { fg = p.orange, bold = glow },
    ['@tag.attribute'] = { fg = p.violet_dim, italic = true },
    ['@tag.delimiter'] = { fg = p.grey_br },
    ['@diff.plus'] = { fg = p.blue_lit },
    ['@diff.minus'] = { fg = p.red },
    ['@diff.delta'] = { fg = p.orange },

    -- LSP semantic tokens
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.decorator'] = { link = '@attribute' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.macro'] = { link = '@function.macro' },
    ['@lsp.type.namespace'] = { link = '@module' },
    ['@lsp.type.parameter'] = { link = '@variable.parameter' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.struct'] = { link = '@type' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.typeParameter'] = { link = '@type.definition' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.mod.deprecated'] = { strikethrough = true },
    ['@lsp.mod.readonly'] = { link = '@constant' },

    LspReferenceText = { bg = p.bg_glow },
    LspReferenceRead = { bg = p.bg_glow },
    LspReferenceWrite = { bg = p.bg_glow, underline = true },
    LspInlayHint = { fg = p.grey, bg = p.bg_alt, italic = true },
    LspSignatureActiveParameter = { fg = p.orange_br, bold = true },
    LspCodeLens = { fg = p.grey, italic = true },

    -- Diagnostics: no green in the source art, so blue carries "ok".
    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.orange },
    DiagnosticInfo = { fg = p.blue_lit },
    DiagnosticHint = { fg = p.violet },
    DiagnosticOk = { fg = p.blue_soft },
    DiagnosticUnderlineError = { sp = p.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.orange, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.blue_lit, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.violet, undercurl = true },
    DiagnosticUnderlineOk = { sp = p.blue_soft, undercurl = true },
    DiagnosticVirtualTextError = { fg = p.red, bg = '#1c0d0a' },
    DiagnosticVirtualTextWarn = { fg = p.orange, bg = '#1b1109' },
    DiagnosticVirtualTextInfo = { fg = p.blue_lit, bg = '#0d1226' },
    DiagnosticVirtualTextHint = { fg = p.violet, bg = '#150f22' },
    DiagnosticVirtualTextOk = { fg = p.blue_soft, bg = '#0d1226' },
    DiagnosticUnnecessary = { fg = p.grey, italic = true },
    DiagnosticDeprecated = { fg = p.grey, strikethrough = true },

    -- Diff / git
    DiffAdd = { fg = p.blue_lit, bg = '#0c1430' },
    DiffChange = { fg = p.orange, bg = '#1a1109' },
    DiffDelete = { fg = p.red, bg = '#1e0a06' },
    DiffText = { fg = p.orange_br, bg = '#2a1a0c', bold = true },
    Added = { fg = p.blue_lit },
    Changed = { fg = p.orange },
    Removed = { fg = p.red },
    GitSignsAdd = { fg = p.blue },
    GitSignsChange = { fg = p.orange },
    GitSignsDelete = { fg = p.red_deep },
    GitSignsAddInline = { bg = '#16326b' },
    GitSignsChangeInline = { bg = '#3a2410' },
    GitSignsDeleteInline = { bg = '#4a170e' },
    GitSignsCurrentLineBlame = { fg = p.line_nr, italic = true },

    -- Telescope
    TelescopeNormal = { fg = p.fg_dim, bg = p.bg_alt },
    TelescopeBorder = { fg = p.border, bg = p.bg_alt },
    TelescopeTitle = { fg = p.bg, bg = p.orange, bold = true },
    TelescopePromptNormal = { fg = p.fg_bright, bg = p.bg_glow },
    TelescopePromptBorder = { fg = p.bg_glow, bg = p.bg_glow },
    TelescopePromptTitle = { fg = p.bg, bg = p.orange, bold = true },
    TelescopePromptPrefix = { fg = p.orange },
    TelescopePromptCounter = { fg = p.grey },
    TelescopeResultsTitle = { fg = p.bg_alt, bg = p.bg_alt },
    TelescopePreviewTitle = { fg = p.bg, bg = p.blue_lit, bold = true },
    TelescopeSelection = { fg = p.fg_bright, bg = p.bg_sel, bold = true },
    TelescopeSelectionCaret = { fg = p.orange, bg = p.bg_sel },
    TelescopeMatching = { fg = p.orange_br, bold = true },
    TelescopeMultiSelection = { fg = p.violet },

    -- Neo-tree
    NeoTreeNormal = { fg = p.fg_dim, bg = p.bg_alt },
    NeoTreeNormalNC = { fg = p.grey_br, bg = p.bg_alt },
    NeoTreeWinSeparator = { fg = p.border, bg = p.bg_alt },
    NeoTreeEndOfBuffer = { fg = p.bg_alt, bg = p.bg_alt },
    NeoTreeRootName = { fg = p.orange, bold = true },
    NeoTreeDirectoryName = { fg = p.blue_soft },
    NeoTreeDirectoryIcon = { fg = p.blue },
    NeoTreeFileName = { fg = p.fg_dim },
    NeoTreeFileNameOpened = { fg = p.fg_bright, bold = true },
    NeoTreeFileIcon = { fg = p.grey_br },
    NeoTreeIndentMarker = { fg = p.bg_sel },
    NeoTreeExpander = { fg = p.grey },
    NeoTreeDotfile = { fg = p.grey },
    NeoTreeFilterTerm = { fg = p.orange_br, bold = true },
    NeoTreeTitleBar = { fg = p.bg, bg = p.orange, bold = true },
    NeoTreeCursorLine = { bg = p.bg_sel },
    NeoTreeGitAdded = { fg = p.blue_lit },
    NeoTreeGitModified = { fg = p.orange },
    NeoTreeGitDeleted = { fg = p.red },
    NeoTreeGitUntracked = { fg = p.violet },
    NeoTreeGitIgnored = { fg = p.line_nr },
    NeoTreeGitConflict = { fg = p.red, bold = true },

    -- blink.cmp
    BlinkCmpMenu = { fg = p.fg_dim, bg = p.bg_alt },
    BlinkCmpMenuBorder = { fg = p.border, bg = p.bg_alt },
    BlinkCmpMenuSelection = { fg = p.fg_bright, bg = p.bg_sel, bold = true },
    BlinkCmpScrollBarThumb = { bg = p.border },
    BlinkCmpScrollBarGutter = { bg = p.bg_glow },
    BlinkCmpLabel = { fg = p.fg_dim },
    BlinkCmpLabelDeprecated = { fg = p.grey, strikethrough = true },
    BlinkCmpLabelMatch = { fg = p.orange_br, bold = true },
    BlinkCmpLabelDetail = { fg = p.grey },
    BlinkCmpLabelDescription = { fg = p.grey },
    BlinkCmpKind = { fg = p.violet },
    BlinkCmpSource = { fg = p.grey },
    BlinkCmpDoc = { fg = p.fg_dim, bg = p.bg_alt },
    BlinkCmpDocBorder = { fg = p.border, bg = p.bg_alt },
    BlinkCmpDocSeparator = { fg = p.border, bg = p.bg_alt },
    BlinkCmpSignatureHelp = { fg = p.fg_dim, bg = p.bg_alt },
    BlinkCmpSignatureHelpBorder = { fg = p.border, bg = p.bg_alt },
    BlinkCmpSignatureHelpActiveParameter = { fg = p.orange_br, bold = true },
    BlinkCmpGhostText = { fg = p.line_nr, italic = true },
    BlinkCmpKindText = { fg = p.fg_dim },
    BlinkCmpKindMethod = { fg = p.fg_bright },
    BlinkCmpKindFunction = { fg = p.fg_bright },
    BlinkCmpKindConstructor = { fg = p.violet },
    BlinkCmpKindField = { fg = p.blue_soft },
    BlinkCmpKindVariable = { fg = p.fg },
    BlinkCmpKindClass = { fg = p.violet },
    BlinkCmpKindInterface = { fg = p.violet },
    BlinkCmpKindModule = { fg = p.blue_pale },
    BlinkCmpKindProperty = { fg = p.blue_soft },
    BlinkCmpKindKeyword = { fg = p.orange },
    BlinkCmpKindSnippet = { fg = p.cyan },
    BlinkCmpKindFile = { fg = p.blue_soft },
    BlinkCmpKindFolder = { fg = p.blue },

    -- which-key
    WhichKey = { fg = p.orange, bold = true },
    WhichKeyGroup = { fg = p.blue_soft },
    WhichKeyDesc = { fg = p.fg_dim },
    WhichKeySeparator = { fg = p.grey },
    WhichKeyNormal = { fg = p.fg_dim, bg = p.bg_alt },
    WhichKeyBorder = { fg = p.border, bg = p.bg_alt },
    WhichKeyTitle = { fg = p.bg, bg = p.orange, bold = true },
    WhichKeyIcon = { fg = p.violet },
    WhichKeyIconAzure = { fg = p.blue_lit },
    WhichKeyIconBlue = { fg = p.blue },
    WhichKeyIconCyan = { fg = p.cyan },
    WhichKeyIconGreen = { fg = p.blue_soft },
    WhichKeyIconGrey = { fg = p.grey_br },
    WhichKeyIconOrange = { fg = p.orange },
    WhichKeyIconPurple = { fg = p.violet },
    WhichKeyIconRed = { fg = p.red },
    WhichKeyIconYellow = { fg = p.sand },

    -- todo-comments
    TodoBgTODO = { fg = p.bg, bg = p.blue_lit, bold = true },
    TodoFgTODO = { fg = p.blue_lit },
    TodoSignTODO = { fg = p.blue_lit },
    TodoBgFIX = { fg = p.bg, bg = p.red, bold = true },
    TodoFgFIX = { fg = p.red },
    TodoSignFIX = { fg = p.red },
    TodoBgHACK = { fg = p.bg, bg = p.orange, bold = true },
    TodoFgHACK = { fg = p.orange },
    TodoSignHACK = { fg = p.orange },
    TodoBgWARN = { fg = p.bg, bg = p.orange_br, bold = true },
    TodoFgWARN = { fg = p.orange_br },
    TodoSignWARN = { fg = p.orange_br },
    TodoBgPERF = { fg = p.bg, bg = p.violet, bold = true },
    TodoFgPERF = { fg = p.violet },
    TodoSignPERF = { fg = p.violet },
    TodoBgNOTE = { fg = p.bg, bg = p.cyan, bold = true },
    TodoFgNOTE = { fg = p.cyan },
    TodoSignNOTE = { fg = p.cyan },
    TodoBgTEST = { fg = p.bg, bg = p.sand, bold = true },
    TodoFgTEST = { fg = p.sand },
    TodoSignTEST = { fg = p.sand },

    -- mini.nvim
    MiniStatuslineModeNormal = { fg = p.bg, bg = p.blue_lit, bold = true },
    MiniStatuslineModeInsert = { fg = p.bg, bg = p.orange, bold = true },
    MiniStatuslineModeVisual = { fg = p.bg, bg = p.violet, bold = true },
    MiniStatuslineModeReplace = { fg = p.bg, bg = p.red, bold = true },
    MiniStatuslineModeCommand = { fg = p.bg, bg = p.sand, bold = true },
    MiniStatuslineModeOther = { fg = p.bg, bg = p.cyan, bold = true },
    MiniStatuslineDevinfo = { fg = p.fg_dim, bg = p.bg_glow },
    MiniStatuslineFilename = { fg = p.grey_br, bg = p.bg_alt },
    MiniStatuslineFileinfo = { fg = p.fg_dim, bg = p.bg_glow },
    MiniStatuslineInactive = { fg = p.grey, bg = p.void },
    MiniIconsAzure = { fg = p.blue_lit },
    MiniIconsBlue = { fg = p.blue },
    MiniIconsCyan = { fg = p.cyan },
    MiniIconsGreen = { fg = p.blue_soft },
    MiniIconsGrey = { fg = p.grey_br },
    MiniIconsOrange = { fg = p.orange },
    MiniIconsPurple = { fg = p.violet },
    MiniIconsRed = { fg = p.red },
    MiniIconsYellow = { fg = p.sand },
    MiniSurround = { fg = p.bg, bg = p.orange_br },

    -- indent-blankline
    IblIndent = { fg = p.bg_glow },
    IblWhitespace = { fg = p.bg_glow },
    IblScope = { fg = p.border },

    -- fidget
    FidgetTask = { fg = p.grey },
    FidgetTitle = { fg = p.orange },

    -- mason
    MasonNormal = { fg = p.fg_dim, bg = p.bg_alt },
    MasonHeader = { fg = p.bg, bg = p.orange, bold = true },
    MasonHeaderSecondary = { fg = p.bg, bg = p.blue_lit, bold = true },
    MasonHighlight = { fg = p.blue_soft },
    MasonHighlightBlock = { fg = p.bg, bg = p.blue_soft },
    MasonHighlightBlockBold = { fg = p.bg, bg = p.blue_soft, bold = true },
    MasonMuted = { fg = p.grey },
    MasonMutedBlock = { fg = p.bg, bg = p.grey },
    MasonError = { fg = p.red },

    -- nvim-dap / dap-ui
    DapBreakpoint = { fg = p.red },
    DapBreakpointCondition = { fg = p.orange },
    DapLogPoint = { fg = p.blue_lit },
    DapStopped = { fg = p.orange_br },
    DapStoppedLine = { bg = p.bg_sel },
    DapUINormal = { fg = p.fg_dim, bg = p.bg_alt },
    DapUIVariable = { fg = p.fg },
    DapUIScope = { fg = p.orange },
    DapUIType = { fg = p.violet },
    DapUIValue = { fg = p.blue_soft },
    DapUIModifiedValue = { fg = p.orange_br, bold = true },
    DapUIDecoration = { fg = p.border },
    DapUIThread = { fg = p.blue_lit },
    DapUIStoppedThread = { fg = p.orange },
    DapUISource = { fg = p.blue_pale },
    DapUILineNumber = { fg = p.line_nr },
    DapUIFloatBorder = { fg = p.border, bg = p.bg_alt },
    DapUIWatchesEmpty = { fg = p.grey },
    DapUIWatchesValue = { fg = p.blue_soft },
    DapUIWatchesError = { fg = p.red },
    DapUIBreakpointsPath = { fg = p.blue_pale },
    DapUIBreakpointsInfo = { fg = p.blue_lit },
    DapUIBreakpointsCurrentLine = { fg = p.orange, bold = true },

    -- Snacks / lazygit style floats
    SnacksNormal = { fg = p.fg_dim, bg = p.bg_alt },
    SnacksWinBar = { fg = p.orange, bg = p.bg_alt, bold = true },
  }
end

local terminal = {
  [0] = p.bg_glow,
  p.red,
  p.blue_soft,
  p.sand,
  p.blue_lit,
  p.violet,
  p.cyan,
  p.fg,
  p.grey,
  p.orange_br,
  p.blue_pale,
  '#e3c9a8',
  '#8fb4ff',
  '#cdb8ff',
  p.cyan_pale,
  p.fg_bright,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

function M.load()
  if vim.g.colors_name then
    vim.cmd 'highlight clear'
  end
  if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
  end

  vim.o.background = 'dark'
  vim.g.colors_name = 'industrial-theme'

  for group, spec in pairs(groups()) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  for i = 0, 15 do
    vim.g['terminal_color_' .. i] = terminal[i]
  end
end

return M
