json.schedule do
  json.version @conference.schedule_version if @conference.schedule_version.present?
  json.conference do
    json.title @conference.title
      if @conference.days.length > 0
        json.start @conference.first_day.start_date.strftime('%Y-%m-%d')
        json.end @conference.last_day.end_date.strftime('%Y-%m-%d')
      end
      json.days @conference.days.length
      json.timeslot_duration duration_to_time(@conference.timeslot_duration)
      index = 0
      json.days @conference.days do |day|
        json.index index
        index += 1
        json.date day.start_date.strftime('%Y-%m-%d')
        json.rooms do
          @conference.rooms.public.each do |room|
            json.set! room.name, room.events.public.accepted.scheduled_on(day).order(:start_time) do |event|
              json.id event.id
              json.date event.start_time.iso8601
              json.start event.start_time.strftime('%H:%M')
              json.duration format_time_slots(event.time_slots)
              json.room room.name
              json.slug event.slug
              json.title event.title
              json.subtitle event.subtitle
              json.track event.track.try(:name)
              json.type event.event_type
              json.language event.language
              json.abstract event.abstract
              json.description event.description
              json.persons event.speakers, :id, :full_public_name
              json.links event.links do |link|
                json.url url_for(link.url)
                json.title link.title
              end
            end
          end
        end
      end
  end
end