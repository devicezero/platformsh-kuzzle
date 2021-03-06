--
-- Kuzzle, a backend software, self-hostable and ready to use
-- to power modern apps
--
-- Copyright 2015-2018 Kuzzle
-- mailto: support AT kuzzle.io
-- website: http://kuzzle.io
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- https://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

local hash_tag = KEYS[1]
local node_id = ARGV[1]

local connection_ids = redis.call(
  'SMEMBERS',
  'cluster:node_clients:' .. hash_tag .. node_id)

for i=1, #connection_ids do
  local connection_id = connection_ids[i]

  redis.call(
    'SREM',
    'cluster:node_clients:' .. hash_tag .. node_id,
    connection_id)

  local room_ids = redis.call(
    'SMEMBERS',
    'cluster:client_rooms:' .. hash_tag .. connection_id)

  for j=1, #room_ids do
    local room_id = room_ids[j]

    redis.call(
      'SREM',
      'cluster:client_rooms:' .. hash_tag .. connection_id,
      room_id)
    redis.call(
      'SREM',
      'cluster:room_clients:' .. hash_tag .. room_id,
      connection_id)

    local exists = redis.call(
      'EXISTS',
      'cluster:room_clients:' .. hash_tag .. room_id)

    if exists == 0 then
      redis.call('HDEL', 'cluster:filters:' .. hash_tag, room_id)
    end
  end
end

local version = redis.call('INCR', 'cluster:version' .. hash_tag)

-- Javascript cannot handle integers greater than 2^53 - 1
if version >= 9007199254740991 then
  version = 1
  redis.call('SET', 'cluster:version' .. hash_tag, version)
end
