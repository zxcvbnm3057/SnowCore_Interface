local function MakeVisibleDebuff(buffname, data)
	local ShowBuffIconFn = function(inst)
	end

	if not data.noicon then
		BUFFICONS[buffname] = data.bufficons
		BUFFSTRINGS[buffname] = data.buffstrings

		ShowBuffIconFn = function(inst)
			local parent = inst.entity:GetParent()
			if
				parent and parent:IsValid() and parent.HUD and parent.HUD.controls and parent.HUD.controls.VisibleDebuffUI and
					not data.noicon
			 then
				local name = inst.replica.visibledebuff:GetName()
				local percent = inst.replica.visibledebuff:GetPercent()
				local activated = inst.replica.visibledebuff:IsActivated()
				parent.HUD.controls.VisibleDebuffUI:AddBuff(name, inst, percent, activated, data.ispositive)
			end
		end
	end

	local function ApplyDebuff(inst, target)
		if inst.ticktask then
			inst.ticktask:Cancel()
			inst.ticktask = nil
		end
		if data.tick_task then
			inst.ticktask = inst:DoPeriodicTask(data.tick_period or 1, data.tick_task)
		end
	end

	local function RemoveDebuff(inst, target)
		if inst.ticktask then
			inst.ticktask:Cancel()
			inst.ticktask = nil
		end
	end

	local function OnAttached(inst, target)
		inst.entity:SetParent(target.entity)

		if not data.keep_on_death then
			inst:ListenForEvent(
				"death",
				function()
					inst.components.visibledebuff:Stop()
				end,
				target
			)
		end

		if data.OnAttached then
			data.OnAttached(inst, target)
		end
	end

	local function OnDetached(inst, target)
		RemoveDebuff(inst, target)
		if data.OnDetached then
			data.OnDetached(inst, target)
		end
		inst:Remove()
	end

	local function OnExtended(inst, target)
		if inst.components.visibledebuff:IsActivated() then
			RemoveDebuff(inst, target)
			inst:DoTaskInTime(
				0,
				function()
					ApplyDebuff(inst, target)
				end
			)
		end
		if data.OnExtended then
			data.OnExtended(inst, target)
		end
	end

	local function OnActivated(inst, target, followsymbol, followoffset, activated_num)
		inst:DoTaskInTime(
			0,
			function()
				ApplyDebuff(inst, target)
			end
		)
		if data.OnActivated then
			data.OnActivated(inst, target, activated_num)
		end
	end

	----------------------------------------------------------------------------------------

	local function OnTargetDirty(inst)
		ShowBuffIconFn(inst)
		if data.OnTargetDirty then
			data.OnTargetDirty(inst)
		end
	end

	local function OnPercentDirty(inst)
		ShowBuffIconFn(inst)
		if data.OnPercentDirty then
			data.OnPercentDirty(inst)
		end
	end

	local function OnActivatedDirty(inst)
		ShowBuffIconFn(inst)
		if data.OnActivatedDirty then
			data.OnActivatedDirty(inst)
		end
	end

	local function fn()
		local inst = CreateEntity()
		inst.entity:AddNetwork()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()

		inst:AddTag("CLASSIFIED")

		if not TheNet:IsDedicated() then
			inst:ListenForEvent("ontargetdirty", OnTargetDirty)
			inst:ListenForEvent("onpercentdirty", OnPercentDirty)
			inst:ListenForEvent("onactivateddirty", OnActivatedDirty)
		end
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("visibledebuff")
		inst.components.visibledebuff:SetAttachedFn(OnAttached)
		inst.components.visibledebuff:SetDetachedFn(OnDetached)
		inst.components.visibledebuff:SetExtendedFn(OnExtended)
		inst.components.visibledebuff:SetActivatedFn(OnActivated)
		inst.components.visibledebuff.keep_on_despawn = not data.remove_on_despawn

		if data.duration then
			inst.components.visibledebuff.decrease_rate = 1 / data.duration
		end

		if data.duration_activated then
			inst.components.visibledebuff.decrease_rate_activated = 1 / data.duration_activated
		end

		return inst
	end
	return Prefab(buffname, fn)
end

return MakeVisibleDebuff
