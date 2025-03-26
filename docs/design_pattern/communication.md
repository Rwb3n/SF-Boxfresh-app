---
layout: default
title: "Customer Communication"
parent: "Design Pattern"
nav_order: 3
---

# Customer Communication

The BoxFresh App includes a comprehensive system for customer communication throughout the service lifecycle. This design pattern ensures timely, relevant, and personalized communication with customers.

## Communication Channels

The app supports multiple communication channels to accommodate customer preferences:

### 1. Email

- **Service Confirmations**: Detailed service details sent upon booking
- **Reminder Emails**: Sent 24 hours before scheduled service
- **Completion Reports**: Summary of completed work with any notes
- **Invoices**: Billing information with payment instructions

### 2. SMS

- **Appointment Reminders**: Brief service reminders sent day-of
- **Status Updates**: Real-time updates about service progress
- **Feedback Requests**: Short messages requesting service ratings

### 3. Customer Portal

- **Document Access**: Service agreements and invoices
- **Schedule Management**: View and request changes to appointments
- **Service History**: View past services and materials used

## Communication Triggers

Communications are automatically triggered by key events in the service lifecycle:

### Order Creation

When a new Order__c record is created, the system:
1. Sends a confirmation email with service details
2. Adds the appointment to the customer portal
3. Schedules follow-up reminders

### Day Before Service

24 hours before a scheduled service, the system:
1. Sends a reminder email with service details
2. Sends an SMS reminder with technician information
3. Updates the customer portal with current status

### Day of Service

On the day of service, the system:
1. Sends an SMS when the technician is en route
2. Updates the portal as service status changes
3. Sends notifications for any schedule changes

### Service Completion

When an Assignment__c is marked as completed, the system:
1. Sends a completion email with service summary
2. Requests customer feedback via email and SMS
3. Updates the portal with completion details and next steps

## Template Management

The app uses a structured template system to maintain consistent messaging:

### Email Templates

```apex
// Example email template retrieval
public static Messaging.SingleEmailMessage prepareServiceConfirmation(Id orderId) {
    Order__c order = [
        SELECT Id, Service_Date__c, Core_Contract__r.Account__r.Name,
               Core_Contract__r.Account__r.PersonEmail
        FROM Order__c
        WHERE Id = :orderId
    ];
    
    EmailTemplate template = [
        SELECT Id, Subject, HtmlValue, Body
        FROM EmailTemplate
        WHERE DeveloperName = 'Service_Confirmation'
    ];
    
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setTemplateId(template.Id);
    email.setTargetObjectId(order.Core_Contract__r.Account__c);
    email.setWhatId(order.Id);
    
    return email;
}
```

### SMS Templates

```apex
// Example SMS template retrieval
public static String prepareSmsReminder(Id assignmentId) {
    Assignment__c assignment = [
        SELECT Id, Start_Time__c, 
               Resource_Unit__r.Name,
               Order__r.Core_Contract__r.Account__r.PersonMobilePhone
        FROM Assignment__c
        WHERE Id = :assignmentId
    ];
    
    String formattedTime = assignment.Start_Time__c.format('h:mm a');
    String message = 'BoxFresh Gardens reminder: Your service is scheduled for ' + 
                    formattedTime + ' tomorrow with ' + 
                    assignment.Resource_Unit__r.Name + '. Reply HELP for assistance.';
    
    return message;
}
```

## Personalization

Communications are personalized based on customer data:

### Customer Preferences

Stored in the Account object:
- Preferred contact method
- Preferred contact time
- Communication opt-ins/opt-outs

### Dynamic Content

Content is dynamically generated based on:
- Service history
- Contract terms
- Customer property details

### Example Implementation

```apex
public static void sendPersonalizedReminder(Id orderId) {
    Order__c order = [
        SELECT Id, Service_Date__c, 
               Core_Contract__r.Account__r.Name,
               Core_Contract__r.Account__r.Preferred_Contact_Method__c,
               (SELECT Id FROM Property__r)
        FROM Order__c
        WHERE Id = :orderId
    ];
    
    // Get property details for personalization
    Property__c property = [
        SELECT Id, Name, Special_Instructions__c
        FROM Property__c
        WHERE Id = :order.Property__r[0].Id
    ];
    
    // Send via preferred method
    switch on order.Core_Contract__r.Account__r.Preferred_Contact_Method__c {
        when 'Email' {
            sendReminderEmail(order, property);
        }
        when 'SMS' {
            sendReminderSms(order, property);
        }
        when 'Both' {
            sendReminderEmail(order, property);
            sendReminderSms(order, property);
        }
    }
}
```

## Feedback Loop

The communication system includes a feedback loop for continuous improvement:

### Feedback Collection

- **Service Ratings**: Simple 1-5 scale ratings
- **Detailed Surveys**: Occasional detailed feedback requests
- **Response Tracking**: Monitoring of customer engagement

### Response Management

- **Alert Triggers**: Low ratings trigger immediate follow-up
- **Trend Analysis**: Identify patterns in feedback
- **Service Improvement**: Update service protocols based on feedback

### Implementation Example

```yaml
feedback_flow:
  trigger: Assignment_Status__c = 'Completed'
  steps:
    - send_survey:
        channel: Email
        template: Service_Feedback
        delay: 1 hour
        
    - monitor_response:
        duration: 24 hours
        
    - if_no_response:
        action: Send_SMS_Reminder
        
    - if_rating_below_4:
        action: Create_Follow_Up_Task
        assignee: Account_Manager
        
    - store_results:
        record: Customer_Feedback__c
        link_to: 
          - Assignment__c
          - Order__c
          - Account__c
```

## Benefits of the Communication Pattern

1. **Increased Customer Satisfaction**: Proactive communication reduces uncertainty
2. **Reduced Support Requests**: Preventive communication answers common questions
3. **Higher Retention**: Well-informed customers are more likely to remain loyal
4. **Improved Service Delivery**: Feedback loop drives continuous improvement
5. **Enhanced Brand Perception**: Professional communication reinforces brand quality 