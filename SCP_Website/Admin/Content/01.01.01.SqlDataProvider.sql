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
	[DesktopHtml] [ntext] NOT NULL,
	[DesktopSummary] [ntext] NULL,
	[CreatedByUserID] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Publish] [bit] NULL,
 CONSTRAINT [PK_scp_Content_1] PRIMARY KEY CLUSTERED 
(
	[ContentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
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


/** Drop Existing Stored Procedures **/

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_AddContent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_AddContent
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_GetContent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_GetContent
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.[scp_UpdateContent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure dbo.scp_UpdateContent
GO

/** Create Stored Procedures **/

GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[scp_AddContent]    Script Date: 10/25/2007 13:30:51 ******/
SET ANSI_NULLS ON
CREATE procedure [dbo].[scp_AddContent]

	@ContentId		int,
	@ModuleId       int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int,
	@Publish		bit

as

if (@Publish = 1)
begin
	update scp_Content set Publish = 0 where ModuleId = @ModuleId
End 

if exists (select * from scp_Content where ModuleId = @ModuleId and DesktopHtml like @DesktopHtml and DesktopSummary like @DesktopSummary)

	update scp_Content
	set    Publish          = @Publish
	where  ContentId = @ContentId

else

	insert into scp_Content (
		ModuleId,
		DesktopHtml,
		DesktopSummary,
		CreatedByUserID,
		CreatedDate,
		Publish
	) 
	values (
		@ModuleId,
		@DesktopHtml,
		@DesktopSummary,
		@UserID,
		getdate(),
		@Publish
	)

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


/****** Object:  StoredProcedure [dbo].[scp_UpdateContent]    Script Date: 10/25/2007 13:33:10 ******/
CREATE procedure [dbo].[scp_UpdateContent]

	@ContentId		int,
	@DesktopHtml    ntext,
	@DesktopSummary ntext,
	@UserID         int,
	@Publish		bit

as

if (@Publish = 1)
begin
	update scp_Content set Publish = 0 where ModuleId = (select ModuleId from scp_Content where ContentId = @ContentId)
End 

update scp_Content
set    DesktopHtml		= @DesktopHtml,
       DesktopSummary	= @DesktopSummary,
       CreatedByUserID  = @UserID,
       CreatedDate		= getdate(),
	   Publish         = @Publish
where  ContentId = @ContentId

GO


/************************************************************/
/*****              SqlDataProvider                     *****/
/************************************************************/