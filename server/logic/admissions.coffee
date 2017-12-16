#######################################################
#
# Created by Markus
#
#######################################################

#######################################################
@gen_admissions = (collection_name, item_id, admissions) ->
	if not collection_name
		throw new Meteor.Error "collection_name need to be defined"

	if not item_id
		throw new Meteor.Error "Item need to be defined"

	if not admissions
		throw new Meteor.Error "Mails need to be defined"

	collection = get_collection_save collection_name
	item = collection.findOne item_id

	users = []
	for a in admissions
		user = Accounts.findUserByEmail a.email
		if not user
			continue

		gen_admission collection_name, item, user, a.role
		users.push user

	return users


#######################################################
@gen_admission = (collection, item, user, role) ->
	if typeof collection != "string"
		collection = collection._name

	if typeof item != "string"
		item = item._id

	if typeof user != "string"
		user = user._id

	if typeof role != "string"
		throw "Role needs to be a string found: " + role

	filter =
		collection_name: collection
		resource_id: item
		consumer_id: user
		role: role

	admission = Admissions.findOne filter
	if admission
		msg = "item already in list"
		log_event msg
		return item._id

	item_id = Admissions.insert filter
	return item_id


#######################################################
@get_admissions = (item, skip, limit) ->
	limit = if limit < 100 then limit else 100

	filter =
		resource_id: item._id

	options =
		fields:
			resource_id: 1
			member_id: 1
			role: 1
		skip: skip
		limit: limit

	crs = Admissions.find(filter, options)
	return crs