namespace IOI.ContractIQ;

using System.Environment;

page 70009 "Event List IOI"
{
    ApplicationArea = All;
    Caption = 'Event List';
    PageType = List;
    SourceTable = "Event Subscription";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Publisher Object Type"; Rec."Publisher Object Type")
                {
                    ToolTip = 'Specifies the type of object that contains the event publisher function that publishes the event.';
                }
                field("Publisher Object ID"; Rec."Publisher Object ID")
                {
                    ToolTip = 'Specifies the ID of the object that contains the event publisher function that publishes the event.';
                }
                field("Published Function"; Rec."Published Function")
                {
                    ToolTip = 'Specifies the name of the event publisher function in the publisher object that the event subscriber function subscribes to.';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies if the event subscription is active.';
                }
                field("Active Manual Instances"; Rec."Active Manual Instances")
                {
                    ToolTip = 'Specifies manual event subscriptions that are active.';
                }
                field("Error Information"; Rec."Error Information")
                {
                    ToolTip = 'Specifies an error that occurred for the event subscription.';
                }
                field("Event Type"; Rec."Event Type")
                {
                    ToolTip = 'Specifies the event type, which can be Business, Integration, or Trigger.';
                }
                field("Number of Calls"; Rec."Number of Calls")
                {
                    ToolTip = 'Specifies how many times the event subscriber function has been called. The event subscriber function is called when the published event is raised in the application.';
                }
                field("Originating App Name"; Rec."Originating App Name")
                {
                    ToolTip = 'Specifies the object that triggers the event.';
                }
                field("Originating Package ID"; Rec."Originating Package ID")
                {
                    ToolTip = 'Specifies the object that triggers the event.';
                }
                field("Subscriber Codeunit ID"; Rec."Subscriber Codeunit ID")
                {
                    ToolTip = 'Specifies the ID of codeunit that contains the event subscriber function.';
                }
                field("Subscriber Function"; Rec."Subscriber Function")
                {
                    ToolTip = 'Specifies the event subscriber function in the subscriber codeunit that subscribes to the event.';
                }
                field("Subscriber Instance"; Rec."Subscriber Instance")
                {
                    ToolTip = 'Specifies the event subscription.';
                }
            }
        }
    }
}
