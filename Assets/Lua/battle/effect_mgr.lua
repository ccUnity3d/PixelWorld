--[[
	战斗管理器
--]]
local GameObject = UnityEngine.GameObject
local Sequence = DG.Tweening.Sequence
local Tweener = DG.Tweening.Tweener
local DOTween = DG.Tweening.DOTween
local gameObject

local effect_mgr = {}
local TAG = "effect_mgr"

local gameObject
local transform
local ui_root

function effect_mgr.init()

end

function effect_mgr.create_hit_label(wpos, num)
	local pos = battle.camera:WorldToScreenPoint(wpos)

    local go = ObjectPool.Spawn('CritNum', battle.canvas_hud)
    go.transform.position = pos
	text = go:GetComponent("Text")
	text.text = num

	-- move
	local rt = go:GetComponent('RectTransform')
	local scale = rt:DOScale(2, 0.1)
	local scale2 = rt:DOScale(1, 0.2)
	local move = rt:DOMoveY(pos.y+50, 1, false)
	local sequence = DOTween.Sequence()
	sequence:Append(scale)
	sequence:Append(scale2)
	sequence:Append(move)
	sequence:AppendCallback(DG.Tweening.TweenCallback(function ()
		-- remove
		ObjectPool.Recycle(go)
	end))
	sequence:Play()

	-- alpha
	text:CrossFadeAlpha(0, 1, true)
end

function effect_mgr.create_hit(parent)
	
    local go = ObjectPool.Spawn('Hit', parent, Vector3.New(0, 0.5, 0), 0.5)
	--go.transform:SetParent(parent)
	--go.transform.localScale = Vector3.one
	--go.transform.localPosition = Vector3.New(0, 0.5, 0)
end

_G['effect_mgr'] = effect_mgr

return effect_mgr