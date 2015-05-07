USE --insert database name here
GO

-- This merges two team member tables together.  First check your target table to see which columns you need to update, or rows to insert...

SELECT  *
FROM    team.[TeamMember] AS TM

--now create your source table, which you want to merge with your target table.

CREATE TABLE dbo.testmerge
    (
      TeamId INT NOT NULL ,
      UserID INT NOT NULL ,
      AddedOn DATETIME NOT NULL ,
      AddedBy INT NOT NULL
    )

INSERT  INTO [dbo].[testmerge]
        ( [TeamId], [UserID], [AddedOn], [AddedBy] )
VALUES  ( 268, 1, GETDATE(), 1 ),
        ( 269, 1, GETDATE(), 1 ),
        ( 190, 1, GETDATE(), 1 ),
        ( 231, 1, GETDATE(), 1 )

SELECT  *
FROM    dbo.[testmerge] AS T

-- now create your merge

BEGIN TRANSACTION

MERGE team.[TeamMember] AS [TARGET]
USING [dbo].[testmerge] AS [SOURCE]
ON [Target].userid = [Source].userid
    AND [target].teamid = [source].teamid
WHEN NOT MATCHED THEN
    INSERT ( Teamid ,
             UserID ,
             AddedOn ,
             Addedby
           )
    VALUES ( [Source].TeamID ,
             [Source].UserID ,
             [Source].Addedon ,
             [Source].Addedby
           )
OUTPUT
    $ACTION ,
    deleted.* ,
    inserted.*;
 
ROLLBACK TRANSACTION
