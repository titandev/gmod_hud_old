usermessage.Hook("_Notify", function (msg)
    local txt = msg:ReadString()
    if LocalPlayer():TSMSIsAdmin() or LocalPlayer():GetUserGroup() == "Event Master" then
        notification.AddLegacy( txt, NOTIFY_HINT, 2 )
    end
end)
TSMS = TSMS or {}
TSMS.DefconSettings = TSMS.DefconSettings or {}
TSMS.Defcon = TSMS.Defcon or {}

surface.CreateFont("tsms_main_40", {
    size = 40,
    weight = 625,
    antialias = true,
    shadow = true,
    font = "tahoma"
})

surface.CreateFont("tsms_text_35", {
    size = 35,
    weight = 625,
    antialias = true,
    shadow = true,
    font = "tahoma"
})

surface.CreateFont("tsms_text_22", {
    size = 22,
    weight = 625,
    antialias = true,
    shadow = true,
    font = "tahoma"
})
surface.CreateFont("tsms_hudtext_20", {
    size = 20,
    weight = 625,
    antialias = true,
    shadow = false,
    font = "tahoma",
    
})

surface.CreateFont("tsms_hudtext_18", {
    size = 18,
    weight = 500,
    antialias = true,
    shadow = true,
    font = "tahoma",
})

local ignoredHud = {
    "CHudHealth",
    "CHudBattery",
    "CHudAmmo"
}
hook.Add( "HUDShouldDraw", "hide hud", function( name )
    if table.HasValue(ignoredHud, name) then
        return false
    end
end)
Health = 0 
Defcon = "V"
DefconColor = Color(41,213,41,180)
DefconSettings = {}
offsetD = 0
local GalaticCredit = Material("materials/credits.png")
local HealthIcon = Material("materials/sp_hud_health.png")
local DefconIcon = Material("materials/sp_hud_defcon.png")

local function FormatNumberWithCommas(n)
    return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end
local localplayer = nil

hook.Add("HUDPaint", "TSMS_SUITE_HUD_OLD", function ()
    
    local x, y = 30, ScrH() - 60
    localplayer = LocalPlayer()
    
    local offsetX = 10
    local offsetT = 48
    local baseColor = Color(30,30,30, 240)
    local baseSubColor = Color(30,30,30, 240)-- Color(25,25,25)
    local boxSizeY = 40
    local boxSizeX = 220
    
    /*
        Drawing Health Info
    */
    draw.RoundedBox(0, x, y , boxSizeY, boxSizeX - 180, baseSubColor)
    surface.SetMaterial(HealthIcon)
    surface.SetDrawColor( Color( 255, 255, 255 ) )
    surface.DrawTexturedRect( x + offsetX, y + 8, 25, 25 )
    draw.RoundedBox(0, x + boxSizeY, y , boxSizeX, boxSizeY, baseColor)
    local barLength = 210
    
    local maxHealth = localplayer:GetMaxHealth()
    local myHealth = localplayer:Health()
    Health = math.min(maxHealth, (Health == myHealth and Health) or Lerp(0.1, Health, myHealth))

    local healthRatio = math.Min(Health / maxHealth, 1)
    local healthSubColor = Color(255,255,255, 90)
    -- if not localplayer:Alive() then healthSubColor = Color(255,70,70, 150) end

    draw.RoundedBox(0, x + boxSizeY + 9, y + 10 , barLength - 8, 20, (localplayer:Alive() and Color(255,255,255, 90) or Color(255,70,70, 150)))
    draw.RoundedBox(0, x + boxSizeY + 9, y + 10 , (barLength - 9) * healthRatio, 20, Color(255,255,255))
    draw.DrawText(math.Max(0, math.Round(localplayer:Health())), "tsms_hudtext_20", x + boxSizeY + 105 , y + 8, Color(77, 77, 77, 255), TEXT_ALIGN_CENTER)
  
    
    /*
        Drawing player info
    */

    local textY = y - 32
    local PlayerCredits = localplayer:getDarkRPVar("money")
    draw.RoundedBox(0, x, y - 35, 500 ,boxSizeY - 10, baseColor)
    surface.SetDrawColor( Color( 255, 255, 255, 190) )
    surface.SetMaterial(GalaticCredit)
    surface.DrawTexturedRect( x + 12, y - 30, 20, 20 )
    if PlayerCredits then
        draw.DrawText(FormatNumberWithCommas(PlayerCredits), "tsms_text_22", x + 40, textY, Color(255,255,255,190), TEXT_ALIGN_LEFT)
    end
    draw.DrawText(localplayer:GetName(), "tsms_text_22", x + 490 , textY, Color(255,255,255,190),TEXT_ALIGN_RIGHT)
  
    
 
     /*
        Draw DEFCON info
    */
    offsetX = 280
    local defconLength = 180
    local defconOffset = 0
    
    
    draw.RoundedBox(0, x + offsetX, y , boxSizeY, boxSizeY, baseSubColor)
    draw.RoundedBox(0, x + boxSizeY + offsetX, y , defconLength , boxSizeY, baseColor)
    surface.SetMaterial(DefconIcon)
    surface.SetDrawColor( Color( 255, 255, 255 ) )
    surface.DrawTexturedRect( x + 10 +280, y + 5, 30, 30 )
    if TSMS.DefconSettings.CurrentLevelColor then
        local currentRoman = TSMS.DefconSettings.CurrentLevelRoman
        draw.DrawText(
            "DEFCON", 
            (not (string.len(currentRoman) >= 2) and "tsms_main_40" or "tsms_text_35"), 
            x + offsetT + offsetX, 
            (not (string.len(currentRoman) >= 2) and y or y+1), 
            Color(255,255,255, 170)
        )
        draw.DrawText(
            currentRoman,
            (not (string.len(currentRoman) >= 2) and "tsms_main_40" or "tsms_text_35"), 
            (not (string.len(currentRoman) >= 2) and x + offsetT + 139 + offsetX or x + offsetT + 122 + offsetX), 
            (not (string.len(currentRoman) >= 2) and y or y+1), 
            TSMS.DefconSettings.CurrentLevelColor
        )
    end
end)
