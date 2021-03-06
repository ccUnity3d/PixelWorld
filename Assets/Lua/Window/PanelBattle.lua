
local Sequence = DG.Tweening.Sequence
local Tweener = DG.Tweening.Tweener
local DOTween = DG.Tweening.DOTween

local gameObject
local transform

PanelBattle = {}
local this = PanelBattle
this._name = 'PanelBattle'
local TAG = 'PanelBattle'

-- --------------------------------------------------------------------
--	c# callback
-----------------------------------------------------------------------
function PanelBattle.Awake(obj)
	gameObject = obj
	transform = obj.transform
end

function PanelBattle.OnDestroy()
	gameObject = nil
end

-- --------------------------------------------------------------------
--	mvc notication
-----------------------------------------------------------------------
function PanelBattle:listNotificationInterests()
	return {BATTLE_HP_CHANGE, BATTLE_MP_CHANGE, COIN_CHANGE,}
end
function PanelBattle:handleNotification(notification)
	if gameObject == nil then return end

	local name = notification._name
	if name == BATTLE_HP_CHANGE or name == BATTLE_HP_CHANGE then
		this.RefreshAttrs(notification._body)
	elseif name == COIN_CHANGE then
		this.UpadeCoin(notification._body)
	end

end

function PanelBattle:init( ... )
	this.InitPanel()
end


--初始化面板--
function PanelBattle.InitPanel()

    local userProxy = facade:retrieveProxy("UserProxy")
	this.text_coin_tf = transform:Find("Text Coin")
	this.text_coin = this.text_coin_tf:GetComponent('Text')
	this.text_coin.text = userProxy.Coin

	this.bar_hp = transform:Find('bar hp'):GetComponent('Image')
	this.bar_mp = transform:Find('bar mp'):GetComponent('Image')
	this.bar_hp.fillAmount = 1
	this.bar_mp.fillAmount = 1


	local btn_exit = transform:Find("Button Exit").gameObject

	window = transform:GetComponent('LuaBehaviour')
	window:AddClick(btn_exit, this.OnBtnExit)
end

function PanelBattle.OnBtnExit(go)
	print('OnBtnExit')
    local data = {lanMgr:GetValue('TITLE_TIP'), lanMgr:GetValue('BATTLE_EXIT'), 
    	function (ret) 
    		if ret == 1 then
    			-- exit
            	sceneMgr:GotoScene(SceneID.Main)
    		end 
    	end
		}
    facade:sendNotification(OPEN_WINDOW, {name="PanelAlert", data=data})
end

function PanelBattle.UpadeCoin(data)
	print(TAG, "UpadeCoin")

	this.text_coin.text = data.coin
	
	local scale = this.text_coin_tf:DOScale(1.5, 0.2)
	local scale2 = this.text_coin_tf:DOScale(1, 0.2)
	local sequence = DOTween.Sequence()
	sequence:Append(scale)
	sequence:Append(scale2)
	sequence:Play()

end

function PanelBattle.RefreshAttrs(data)
	print(TAG, "RefreshAttrs")
	if data.hp then
		this.bar_hp.fillAmount = data.hp / 100
	end 
end

return PanelBattle