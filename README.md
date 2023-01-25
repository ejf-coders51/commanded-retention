# Retention

POC to understand if we can set a retention on an eventsourcing system
The app consist of one aggregate that represent a counter

## Implementation

We have created a command that emit an event that represent an aggregate snapshot.
This event is used to replay the aggregate and the projections

# Test precondition

database: `docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:14`

init database: `mix do ecto.drop, ecto.create, event_store.create, event_store.init, ecto.migrate`

# Test

Running a shell with: `iex -S mix run`
we can run this command: `Mix.Task.rerun("retention")` that do the following:
* create a counter starting from 1
* increase up to 10
* trigger the retention
* replay the projections
* increate the counter 2 more times

# Result

If we query the projection the counter is 12 and the events on the table are 1 snapshot plus 2 increase
