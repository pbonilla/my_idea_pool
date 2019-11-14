json.idea do
  json.id @idea.id
  json.content @idea.content
  json.average_score @idea.average_score
  json.impact @idea.impact
  json.ease @idea.ease
  json.confidence @idea.confidence
  json.created_at @idea.created_at.to_i
end