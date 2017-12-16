########################################
Template.organization_profile.onCreated ->
	this.parameter = new ReactiveDict()
	this.parameter.set "item_id", get_profile()._id
	this.parameter.set "collection_name", "profiles"


########################################
Template.organization_profile.helpers
	parameter: () ->
		return Template.instance().parameter


########################################
Template.organization_profile.events
	"click #add_member": (event) ->
		mails = Template.instance().find("#mails").value
		profile = get_profile()
		mails =
			email: mails
			role: OWNER

		Meteor.call "add_admissions", "profiles", profile._id, [mails],
			(res, err) ->
				if err
					sAlert.error(err)
				else
					sAlert.success("Invitation send.")


########################################
Template.collaborator.onCreated ->
	self = this
	self.send_disabled = new ReactiveVar(false)

	console.log self.data

	self.autorun ->
		user_id = self.data.member_id
		self.subscribe "collaborator", user_id

