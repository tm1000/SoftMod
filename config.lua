-- Server/community branding config.
-- Everything here identifies THIS server's community to players (Discord,
-- website, patreon, logos, QR codes). Swap these values to rebrand for a
-- different server without touching the mod's own generic UI icons or the
-- M45-SoftMod project attribution (GitHub links, "M45-SoftMod" version text).
return {
    -- Discord invite shown to players (full link, and a bare "domain/code"
    -- form used for compact in-world text near spawn).
    discord_url = "https://discord.gg/nFCrGkxjf7",
    discord_display = "discord.gg/nFCrGkxjf7",

    -- Community website.
    website_url = "https://e81.us",
    website_display = "e81.us",

    -- Patreon page.
    patreon_url = "",

    -- Factorio server-browser search URL tagged to this community.
    server_list_url = "",

    -- Community subreddit, shown as plain text (not a clickable link).
    reddit_handle = "",

    -- Community display name, used in the info window and tooltips.
    community_name = "E81",
    community_short = "E81",

    -- Server-identity sprites (spawn logo, info-window logo, QR codes).
    -- Generic functional icons (todo list, online list, force-delete, etc.)
    -- are not branding and stay hardcoded in their own files.
    logo_spawn_pad = "file/img/world/e81-pad.png",
    logo_button = "file/img/buttons/m45-64.png",
    logo_info_win = "file/img/info-win/e81-128.png",
    discord_icon = "file/img/info-win/discord-64.png",
    discord_qr = "file/img/info-win/e81-discord.png",
    patreon_icon = "file/img/info-win/patreon-64.png",
    patreon_qr = "file/img/info-win/patreon-qr.png",
}
