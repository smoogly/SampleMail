# Sample mail app


## Definitions

Mailbox is the whole setup representing a mailing address.

Message is a single email.  
Draft is a Message that has not been sent yet.


Thread is a set of Messages representing a single conversation.  
  * Messages may be joined into a Thread by title or contents or other factors.  
  * Single Message can not belong to multiple Threads, otherwise it's a faulty join.


Folder is a set of Messages organized by some feature other than Threads
  * Single Message may belong to multiple Folders (folders are just a criteria to select messages against).
  * When viewing a Message from a Folder,
      other Messages from the same Thread should also be visible
      even if they belong to other Folders.


Searching is creating a virtual Folder organized around the search query as a criteria.
