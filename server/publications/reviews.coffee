#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_review_fields =
	fields:
		rating: 1
		content: 1
		published: 1
		solution_id: 1
		challenge_id: 1

#######################################################
# reviews
#######################################################

#######################################################
Meteor.publish "my_reviews", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Reviews, {}, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "my_reviews", user_id
	return crs


#######################################################
Meteor.publish "my_review_by_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter = {_id: review_id}
	crs = get_documents filter, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "my_review_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_reviews_by_challenge_id", (challenge_id) ->
	check challenge_id, String
	user_id = this.userId

	filter =
		challenge_id: challenge_id

	crs = get_my_documents Reviews, filter, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "reviews_by_solution_id", user_id
	return crs

#######################################################
Meteor.publish "reviews_by_solution_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	filter =
		solution_id: solution_id
		published: true

	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "reviews_by_solution_id", user_id
	return crs

