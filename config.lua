Config = {}

Config['Base_Events'] = {
    ['playerSpawned'] = 'playerSpawned',
    ['onPlayerDeath'] = 'esx:onPlayerDeath',
    ['playerLoaded'] = 'esx:playerLoaded',
    ['playerDropped'] = 'esx:playerDropped',
    ['setJob'] = 'esx:setJob',
}
Config['ClientDistance'] = 5.0 -- Player Move Distance > 5.0 distance Update Squad or Blip
Config['ClientDelay'] = 10000 -- Don't Touch , if you don't know
Config['ServerDelay'] = 60000 -- Don't Touch , if you don't know

Config['Squad'] = {
    ['unemployed'] = {
        Enable = true,
        Label = 'Police',
        BlipSprite = 1,
        BlipScale = 0.7,
        BlipColour = 18,
        PlayerDeathShow = false
    },
    -- ['example'] = {
    --     Enabled = true,
    --     Label = 'Police',
    --     BlipSprite = 1,
    --     BlipScale = 0.7,
    --     BlipColour = 18,
    --     ClientDelay = 1500,
    --     PlayerDeathShow = false
    -- },
}