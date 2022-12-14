CREATE FUNCTION full_suggestions_info (user_id text) RETURNS TABLE(
  suggestion_id int,
  title text,
  description text,
  labels text [ ],
  images text [ ],
  author_id text,
  status text,
  anonymous boolean,
  creation_time timestamp,
  upvotes_count int,
  should_notify_after_completed boolean,
  is_voted boolean
) AS $$
    select *, 
(select Count(*) from voted_user_relation where voted_user_relation.suggestion_id = suggestions.suggestion_id) as upvotes_count,
suggestion_id in (select suggestion_id from subscribed_user_relation where user_id = $1) as should_notify_after_completed,
suggestion_id in (select suggestion_id from voted_user_relation where user_id = $1) as is_voted
from suggestions;
$$ LANGUAGE SQL;

CREATE FUNCTION full_suggestions_info_v1() RETURNS TABLE(
  suggestion_id int,
  title text,
  description text,
  labels text [ ],
  images text [ ],
  author_id text,
  status text,
  anonymous boolean,
  creation_time timestamp,
  voted_user_ids text [],
  notify_user_ids text []
) AS $$
  select *, 
    (select ARRAY_AGG(user_id) from voted_user_relation where suggestion_id = suggestions.suggestion_id group by suggestion_id) as voted_user_ids,
    (select ARRAY_AGG(user_id) from subscribed_user_relation where suggestion_id = suggestions.suggestion_id group by suggestion_id) as notify_user_ids
      from suggestions
$$ LANGUAGE SQL;