/**
* @name AnnouncementQueueable
* @description This class posts Chatter Announcements
**/
public class AnnouncementQueueable implements Queueable {
    
    public List<ConnectApi.AnnouncementInput> toPost {get; set;}
    
    //ToDo: Modify this class to implement the Queueable interface and call the postAnnouncements method
    
    
    /**
* @name postAnnouncements
* @description This method is provided for you to facilitate the Super Badge
**/
    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        // Both if statements need to manage the while loop counter, so update the if and else/if to remove items from the announcements list. 
        // However, instead of doing separate announcements, bunch them together, then pass to an instance of AnnouncementQueueable's toPost property
        List<ConnectApi.AnnouncementInput> al = new List<ConnectApi.AnnouncementInput>();
        while ( announcements.size() > 0 ){
            if (Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !Test.isRunningTest()){
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else {
                break;
            } 
            }
        if (Limits.getDmlStatements() > Limits.getLimitDmlStatements() && !Test.isRunningTest()){
            Integer numChunks = Integer.valueOf(Limits.getDmlStatements() / 150) + Math.mod(Limits.getDmlStatements(), 150);
            for (Integer i = 0; i < numChunks; i++) {
                for (Integer ii = 0; ii < 150; ii++) {
                    al.add(announcements[ii]);
                }
                AnnouncementQueueable aq = new AnnouncementQueueable();
                aq.toPost = al;
                System.enqueueJob(aq);
            } 
    }
    }
    
    public void execute(QueueableContext context){
        PostAnnouncements(this.toPost);
    }
    
}