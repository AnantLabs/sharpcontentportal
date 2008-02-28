USE [scp]
GO
/**
drop table dbo.scp_contentcomment
drop table dbo.scp_content
drop view dbo.scp_vw_content
drop view dbo.scp_vw_contentcomment
**/
/************************************************************/
/*****              SqlDataProvider                     *****/
/*****                                                  *****/
/*****                                                  *****/
/***** Note: To manually execute this script you must   *****/
/*****       perform a search and replace operation     *****/
/*****       for dbo. and scp_  *****/
/*****                                                  *****/
/************************************************************/

/** Create Table **/
/****** Object:  Table [dbo].[scp_Content]    Script Date: 10/25/2007 13:26:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[scp_Content](
	[ContentID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[DesktopHtml] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DesktopSummary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedByUserID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Publish] [bit] NOT NULL CONSTRAINT [DF_scp_Content_Publish]  DEFAULT ((0)),
	[WorkflowState] [smallint] NOT NULL CONSTRAINT [DF_scp_Content_CommentFlag]  DEFAULT ((0)),
 CONSTRAINT [PK_scp_Content_1] PRIMARY KEY CLUSTERED 
(
	[ContentID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[scp_Content]  WITH NOCHECK ADD  CONSTRAINT [FK_scp_Content_scp_Modules] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[scp_Modules] ([ModuleID])
ON DELETE CASCADE
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[scp_Content] CHECK CONSTRAINT [FK_scp_Content_scp_Modules]
GO
ALTER TABLE [dbo].[scp_Content]  WITH NOCHECK ADD  CONSTRAINT [FK_scp_Content_scp_Users] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[scp_Users] ([UserID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[scp_Content] CHECK CONSTRAINT [FK_scp_Content_scp_Users]

CREATE TABLE [dbo].[scp_ContentComment](
	[CommentID] [int] IDENTITY(1,1) NOT NULL,
	[ContentID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[CommentDate] [datetime] NOT NULL,
	[Comment] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_scp_ContentComment] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[scp_ContentComment]  WITH CHECK ADD  CONSTRAINT [FK_scp_ContentComment_scp_Content] FOREIGN KEY([ContentID])
REFERENCES [dbo].[scp_Content] ([ContentID])
GO
ALTER TABLE [dbo].[scp_ContentComment] CHECK CONSTRAINT [FK_scp_ContentComment_scp_Content]
GO
ALTER TABLE [dbo].[scp_ContentComment]  WITH CHECK ADD  CONSTRAINT [FK_scp_ContentComment_scp_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[scp_Users] ([UserID])
GO
ALTER TABLE [dbo].[scp_ContentComment] CHECK CONSTRAINT [FK_scp_ContentComment_scp_Users]

/** /Create Views **/
GO
CREATE VIEW [dbo].[scp_vw_Content]
AS
SELECT     (SELECT     COUNT(ModuleID) AS Expr1
                       FROM          dbo.scp_Content
                       WHERE      (ModuleID = C.ModuleID) AND (CreatedDate <= C.CreatedDate)) AS ContentVersion, C.*, U.Username, U.FirstName, U.LastName
FROM         dbo.scp_Content AS C INNER JOIN
                      dbo.scp_Users AS U ON C.CreatedByUserID = U.UserID
GO
CREATE VIEW [dbo].[scp_vw_ContentComment]
AS
SELECT     dbo.scp_ContentComment.*, dbo.scp_Users.Username, dbo.scp_Users.FirstName, dbo.scp_Users.LastName
FROM         dbo.scp_ContentComment INNER JOIN
                      dbo.scp_Users ON dbo.scp_ContentComment.UserID = dbo.scp_Users.UserID

/** Drop Existing Stored Procedures **/
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_AddContent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_AddContent
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_AddContentComment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_AddContentComment
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_GetContent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_GetContent
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_GetContentById]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_GetContentById
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_GetContentComments]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_GetContentComments
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_GetContentVersions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_GetContentVersions
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_UpdateContent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_UpdateContent
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_UpdateContentPublish]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_UpdateContentPublish
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_UpdateContentWorkflow]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_UpdateContentWorkflow
GO

/** Create Stored Procedures **/
GO
SET QUOTED_IDENTIFIER ON
GO

USE [scp]
/****** Object:  StoredProcedure [dbo].[scp_AddContent] ******/
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[scp_AddContent]

	@ContentId       int,
	@ModuleId       int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int

as

if not exists (select * from scp_Content where ModuleId = @ModuleId and DesktopHtml like @DesktopHtml and DesktopSummary like @DesktopSummary)
begin
	
	insert into scp_Content (
		ModuleId,
		DesktopHtml,
		DesktopSummary,
		CreatedByUserID,
		CreatedDate
	) values (
		@ModuleId,
		@DesktopHtml,
		@DesktopSummary,
		@UserID,
		getdate()
	)

	set @ContentId = SCOPE_IDENTITY()

end

select @ContentId

GO
/****** Object:  StoredProcedure [dbo].[scp_AddContentComment] ******/
CREATE procedure [dbo].[scp_AddContentComment]
	
	@ContentId		int,
	@UserId			int,
	@Comment		ntext

as

declare @CommentId int
set @CommentId = -1

if (Datalength(@Comment) > 0)
begin
	insert into scp_ContentComment (
			ContentId,
			UserId,
			CommentDate,
			Comment
		) values (
			@ContentId,
			@UserId,
			getdate(),
			@Comment
		)

	set @CommentId = SCOPE_IDENTITY()
end

select @CommentId

GO
/****** Object:  StoredProcedure [dbo].[scp_GetContent]    Script Date: 10/25/2007 13:31:53 ******/
CREATE procedure [dbo].[scp_GetContent]

	@ModuleId int

as

select *
from scp_vw_Content
where  ModuleId = @ModuleId
and Publish = 1

GO
/****** Object:  StoredProcedure [dbo].[scp_GetContentById] ******/
CREATE procedure [dbo].[scp_GetContentById]

	@ContentId int

as

select *
from scp_vw_Content
where  ContentId = @ContentId

GO
/****** Object:  StoredProcedure [dbo].[scp_GetContentComments] ******/
CREATE procedure [dbo].[scp_GetContentComments]

	@ContentId int

as

select *
from scp_vw_ContentComment
where  ContentId = @ContentId

GO
/****** Object:  StoredProcedure [dbo].[scp_GetContentVersions] ******/
CREATE procedure [dbo].[scp_GetContentVersions]

	@ModuleId int

as

select *
from scp_vw_Content
where  ModuleId = @ModuleId
ORDER BY ContentVersion

select TotalRecords = COUNT(*)
from scp_vw_Content
where  ModuleId = @ModuleId

GO
/****** Object:  StoredProcedure [dbo].[scp_UpdateContent]    Script Date: 10/25/2007 13:33:10 ******/
CREATE procedure [dbo].[scp_UpdateContent]

	@ContentId		int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@Publish		bit,
	@WorkflowState	smallint

as

if (@Publish = 1)
begin
	update scp_Content set Publish = 0 where ModuleId = (select ModuleId from scp_Content where ContentId = @ContentId)
End 

update scp_Content
set		DesktopHtml		= @DesktopHtml,
		DesktopSummary	= @DesktopSummary,
		Publish         = @Publish,
		WorkflowState	= @WorkflowState
where	ContentId		= @ContentId

GO
/****** Object:  StoredProcedure [dbo].[scp_UpdateContentPublish] ******/
CREATE procedure [dbo].[scp_UpdateContentPublish]

	@ContentId	int
as

update scp_Content set Publish = 0 where ModuleId = (select ModuleId from scp_Content where ContentId = @ContentId)

update scp_Content
set		Publish     = 1
where	ContentId	= @ContentId

GO
/****** Object:  StoredProcedure [dbo].[scp_UpdateContentWorkflow] ******/
CREATE procedure [dbo].[scp_UpdateContentWorkflow]

	@ContentId	int,
	@WorkflowState smallint
as

update scp_Content
set		WorkflowState   = @WorkflowState
where	ContentId		= @ContentId


/************************************************************/
/*****              SqlDataProvider                     *****/
/************************************************************/

