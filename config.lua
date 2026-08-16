-- Server/community branding config.
-- Everything here identifies THIS server's community to players (Discord,
-- website, patreon, logos, QR codes). Swap these values to rebrand for a
-- different server without touching the mod's own generic UI icons or the
-- M45-SoftMod project attribution (GitHub links, "M45-SoftMod" version text).
return {
    -- Discord invite shown to players (full link, and a bare "domain/code"
    -- form used for compact in-world text near spawn).
    discord_url = "https://discord.gg/rQANzBheVh",
    discord_display = "discord.gg/rQANzBheVh",

    -- Community website.
    website_url = "https://m45sci.xyz",
    website_display = "m45sci.xyz",

    -- Patreon page.
    patreon_url = "https://www.patreon.com/m45sci",

    -- Factorio server-browser search URL tagged to this community.
    server_list_url = "http://factorio.go-game.net/?tag=M45",

    -- Community subreddit, shown as plain text (not a clickable link).
    reddit_handle = "/r/M45Sci",

    -- Community display name, used in the info window and tooltips.
    community_name = "M45-Science",
    community_short = "M45",

    -- Server-identity sprites (spawn logo, info-window logo, QR codes).
    -- Generic functional icons (todo list, online list, force-delete, etc.)
    -- are not branding and stay hardcoded in their own files.
    logo_spawn_pad = "file/img/world/m45-pad-v6.png",
    logo_button = "file/img/buttons/m45-64.png",
    logo_info_win = "file/img/info-win/m45-128.png",
    discord_icon = "file/img/info-win/discord-64.png",
    discord_qr = "file/img/info-win/m45-qr.png",
    patreon_icon = "file/img/info-win/patreon-64.png",
    patreon_qr = "file/img/info-win/patreon-qr.png",
}
