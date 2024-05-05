{ colors }: ''
(
  // Maximum number of notifications to show at any one time.
  // A value of 0 means that there is no limit.
  max_notifications: 0,

  // The default timeout, in miliseconds, for notifications that don't have an initial timeout set.
  // 1000ms = 1s.
  timeout: 10_000,

  // `poll_interval` decides decides how often (in milliseconds) Wired checks for new notifications, events,
  // draws notifications (if necessary), etc.
  // Note that when no notifications are present, Wired always polls at 500ms.
  // 16ms ~= 60hz / 7ms ~= 144hz.
  poll_interval: 16,

  // https://github.com/Toqozz/wired-notify/wiki/Shortcuts
  shortcuts: ShortcutsConfig (
    // Left Mouse: Interacts with a block within a notification.
    notification_interact: 1,
    // Right Mouse: Closes the selected notification.
    notification_close: 2,
    // Middle Mouse: Closes all current notifications.
    notification_closeall: 3,
  ),

  layout_blocks: [
    // Layout 1, when an image is present.
    (
      name: "root_image",
      parent: "",
      hook: Hook(parent_anchor: TL, self_anchor: TL),
      offset: Vec2(x: 7.0, y: 7.0),
      render_criteria: [HintImage],
      // https://github.com/Toqozz/wired-notify/wiki/NotificationBlock
      params: NotificationBlock((
        monitor: 0,
        border_width: 0.0,
        border_rounding: 5.0,
        border_color: Color(hex: "${colors.base02}"),
        background_color: Color(hex: "${colors.base00}"),

        gap: Vec2(x: 0.0, y: 8.0),
        notification_hook: Hook(parent_anchor: BL, self_anchor: TL),
      )),
    ),

    (
      name: "image",
      parent: "root_image",
      hook: Hook(parent_anchor: TL, self_anchor: TL),
      offset: Vec2(x: 0.0, y: 0.0),
      // https://github.com/Toqozz/wired-notify/wiki/ImageBlock
      params: ImageBlock((
        image_type: Hint,
        // We actually want 4px padding, but the border is 3px.
        padding: Padding(left: 7.0, right: 0.0, top: 7.0, bottom: 7.0),
        rounding: 5.0,
        scale_width: 48,
        scale_height: 48,
        filter_mode: Lanczos3,
      )),
    ),

    (
      name: "summary_image",
      parent: "image",
      hook: Hook(parent_anchor: MR, self_anchor: BL),
      offset: Vec2(x: 0.0, y: 0.0),
      // https://github.com/Toqozz/wired-notify/wiki/TextBlock
      params: TextBlock((
        text: "%s",
        font: "Noto Sans Bold 11",
        ellipsize: Middle,
        color: Color(hex: "${colors.base07}"),
        color_hovered: Color(hex: "${colors.base05}"),
        padding: Padding(left: 7.0, right: 7.0, top: 7.0, bottom: 0.0),
        dimensions: (width: (min: 50, max: 150), height: (min: 0, max: 0)),
      )),
    ),

    (
      name: "body_image",
      parent: "summary_image",
      hook: Hook(parent_anchor: BL, self_anchor: TL),
      offset: Vec2(x: 0.0, y: -3.0),
      // https://github.com/Toqozz/wired-notify/wiki/ScrollingTextBlock
      params: ScrollingTextBlock((
        text: "%b",
        font: "Noto Sans 11",
        color: Color(hex: "${colors.base07}"),
        color_hovered: Color(hex: "${colors.base05}"),
        padding: Padding(left: 7.0, right: 7.0, top: 3.0, bottom: 7.0),
        width: (min: 150, max: 250),
        scroll_speed: 0.1,
        lhs_dist: 35.0,
        rhs_dist: 35.0,
        scroll_t: 1.0,
      )),
    ),


    // Layout 2, when no image is present. ------------------------------------------
    (
      name: "root",
      parent: "",
      hook: Hook(parent_anchor: TL, self_anchor: TL),
      offset: Vec2(x: 7.0, y: 7.0),
      render_anti_criteria: [HintImage],
      // https://github.com/Toqozz/wired-notify/wiki/NotificationBlock
      params: NotificationBlock((
        monitor: 0,
        border_width: 0.0,
        border_rounding: 5.0,
        border_color: Color(hex: "${colors.base02}"),
        background_color: Color(hex: "${colors.base00}"),

        gap: Vec2(x: 0.0, y: 8.0),
        notification_hook: Hook(parent_anchor: BL, self_anchor: TL),
      )),
    ),

    (
      name: "summary",
      parent: "root",
      hook: Hook(parent_anchor: TL, self_anchor: TL),
      offset: Vec2(x: 0.0, y: 0.0),
      // https://github.com/Toqozz/wired-notify/wiki/TextBlock
      params: TextBlock((
        text: "%s",
        font: "Noto Sans Bold 11",
        ellipsize: Middle,
        color: Color(hex: "${colors.base07}"),
        color_hovered: Color(hex: "${colors.base05}"),
        padding: Padding(left: 7.0, right: 7.0, top: 7.0, bottom: 0.0),
        dimensions: (width: (min: 50, max: 150), height: (min: 0, max: 0)),
      )),
    ),

    (
      name: "body",
      parent: "summary",
      hook: Hook(parent_anchor: BL, self_anchor: TL),
      offset: Vec2(x: 0.0, y: 0.0),
      // https://github.com/Toqozz/wired-notify/wiki/ScrollingTextBlock
      params: ScrollingTextBlock((
        text: "%b",
        font: "Noto Sans 11",
        color: Color(hex: "${colors.base07}"),
        color_hovered: Color(hex: "${colors.base05}"),
        padding: Padding(left: 7.0, right: 7.0, top: 0.0, bottom: 7.0),
        width: (min: 150, max: 250),
        scroll_speed: 0.1,
        lhs_dist: 35.0,
        rhs_dist: 35.0,
        scroll_t: 1.0,
      )),
    ),
  ],
)
''
