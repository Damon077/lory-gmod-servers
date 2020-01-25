if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("mers_base_holdtype")
else
    net.Receive("mers_base_holdtype", function(len)
        local wep = net.ReadEntity()

        if IsValid(wep) and wep:IsWeapon() and wep.SetWeaponHoldType then
            wep:SetWeaponHoldType(net.ReadString())
        end
    end)
end

SWEP.Base = "weapon_base"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Author = "LORY :)"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModelFOV = 50
SWEP.HolsterHoldTime = 0.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:CalculateHoldType()
end

function SWEP:SetNetHoldType(name)
    if self.SetWeaponHoldType then
        self:SetWeaponHoldType(name)
    end

    if SERVER then
        net.Start("mers_base_holdtype")
        net.WriteEntity(self)
        net.WriteString(name)
        net.Broadcast()
    end
end

function SWEP:CalculateHoldType()
    local holdtype = self.HoldType

    -- crouching in passive holdtype looks wierd, use smg instead
    if holdtype == "passive" and IsValid(self.Owner) and self.Owner:Crouching() then
        holdtype = self.HoldType or "smg"
    end

    if self.OldHoldType ~= holdtype then
        self.OldHoldType = holdtype
        self:SetNetHoldType(holdtype)
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster(newWep)
    return true
end