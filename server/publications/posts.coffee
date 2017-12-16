#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "posts", (group_name) ->
	check group_name, String

	user_id = this.userId
	restrict =
		group_name: group_name
		published: true

	crs = Posts.find filter, fields

	log_publication "Posts", crs, filter, restrict, "posts", user_id
	return crs

