# UC-INT-001-01C: Work with Open Houses

## Purpose:

This use case outlines the functionalities for internal users (Dreamhouse employees) to manage open house schedules within the Dreamhouse Agent system. This includes scheduling, displaying, and rescheduling open house events. The goal is to provide tools for employees to efficiently coordinate and manage open house activities.

## What can the agent do?

    - Arrange and Schedule Open House Events.
    - Display open house schedules.
    - Reschedule open house events.

## Sample Utterances:

- Main Tests

    1. When is the next open house at 18 Henry Street?
    2. Schedule an open house at 18 Henry Street next Saturday at 10 AM.
    3. Schedule an open house at 18 Henry Street next Sunday at 3:45 PM. Victor will be the broker for this event
    4. Show me the open house events for 18 Henry Street
    5. List all open houses scheduled for this weekend
    6. Reschedule the open house at 18 Henry Street.
        - Does 18 Henry Street have an open houe next Saturday?
        - Reschedule it for 4:15 PM
        - The broker is Caroline Kingsley

- Other

    1. Can you tell me if there are any open houses scheduled for this weekend?
    2. What are the upcoming open house dates for properties in my area?
    3. Show me the open house schedule for next week.
    4. What open houses are scheduled for this week?
    5. Schedule a new open house at 18 Henry Street next Saturday at 10 AM.
    6. Schedule an open house at 18 Henry Street for next Saturday.
    7. Can you tell me if there are any open houses scheduled for this weekend?
    8. What are the upcoming open house dates for properties in my area?
    9. Schedule an open house for [Address] on [date].
    10. Show me the open house schedule for next week.
    11. What open houses are scheduled for this week?
    12. Reschedule the open house for [Address].
    13. When is the next open house at 18 Henry Street?
    14. Schedule an open house at 18 Henry Street next Saturday.
    15. Schedule an open house at 18 Henry Street for next Saturday.
    16. Can you tell me if there are any open houses scheduled for this weekend?
    17. What are the upcoming open house dates for properties in my area?
    18. Schedule an open house for [Address] on [date].
    19. Show me the open house schedule for next week.
    20. What open houses are scheduled for this week?
    21. Reschedule the open house for [Address].

# Agenforce

Agent, you are to assist Dreamhouse employees with managing open house schedules. You have the capability to schedule new open house events, display existing schedules, and reschedule open houses as needed. When a user provides an address, date, or timeframe, accurately interpret their request and perform the corresponding action. For example, when asked "Schedule an open house for [Address] next Saturday," create a new open house entry for that property on the specified date. If a user asks "When is the next open house for [Address]?" provide the upcoming scheduled date and time. Similarly, for rescheduling requests, modify the existing open house entry accordingly.

===

1. "Properly manage the open house events"
2. Validate with AI
3. "When scheduling a new open house event, ensure to gather all necessary details such as date, time, property. Confirm the details with the user before finalizing the schedule."
4. "When scheduling a new open house event, ensure to gather all necessary details such as date, time, property. Confirm the details with the user before finalizing the schedule, then call action "ETDH: Schedule Property Open House Event"
5. New instruction
   Steps to schedule a new open house event
    1. You must have the Property ID (18 character)
    2. If a broker is desired, you must have the Broker ID (18 character)
    3. Gather all necessary details such as date, time, property. Confirm the details with the user
    4. Call action "ETDH: Schedule Property Open House Event"
    5. Query the newly created open house record and display that
6.

===

Find properties based on their open house events using the 'ETDH: Find Property Open House By Date Range' action. Specify the date range to retrieve the relevant open house information.

===
