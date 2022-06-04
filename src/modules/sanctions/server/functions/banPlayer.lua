---banPlayer
---@param license string
---@param reason string
---@param time table
---@return void
function MOD_Sanctions:banPlayer(license, reason, time)
    if (not license or not reason or not time) then
        return
    end

    if (MOD_Sanctions:isPlayerBan(license)) then
        NCS.coreTrace(_, ("Player %s is already banned."):format(license))
        return
    end

    time = API_Maths:unformatTime(time)
    time = API_Maths:addTimeToUnix(time)
    local ban_id <const> = ("BAN-%s-%s"):format(API_Strings:randomString(3), API_Strings:randomString(5))

    local query <const> = ("INSERT INTO ncs_bans (ban_id, license, reason, time) VALUES ('%s', '%s', '%s', '%i')"):format(ban_id, license, reason, time)
    API_Database:query(query, {}, function(result)
        if (not result) then
            NCS.coreTrace(_, ("Failed to insert ban for player %s."):format(license))
            return
        end
        MOD_Sanctions.List.Bans[license] = {
            ["ban_id"] = ban_id,
            ["license"] = license,
            ["reason"] = reason,
            ["time"] = time
        }
        NCS.coreTrace(_, ("Player %s banned."):format(license))
    end)
end