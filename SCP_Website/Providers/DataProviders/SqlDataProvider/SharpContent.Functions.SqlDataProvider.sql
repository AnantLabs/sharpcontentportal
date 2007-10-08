/****** Object:  UserDefinedFunction [dbo].[dnn_GetElement]    Script Date: 10/05/2007 21:33:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[dnn_GetElement]
(
	@ord AS INT,
	@str AS VARCHAR(8000),
	@delim AS VARCHAR(1) 
)
RETURNS INT

AS

BEGIN
	-- If input is invalid, return null.
	IF  @str IS NULL
		OR LEN(@str) = 0
		OR @ord IS NULL
		OR @ord < 1
		-- @ord > [is the] expression that calculates the number of elements.
		OR @ord > LEN(@str) - LEN(REPLACE(@str, @delim, '')) + 1
		RETURN NULL
 
	DECLARE @pos AS INT, @curord AS INT
	SELECT @pos = 1, @curord = 1
	-- Find next element's start position and increment index.
	WHILE @curord < @ord
		SELECT
			@pos = CHARINDEX(@delim, @str, @pos) + 1,
			@curord = @curord + 1
	RETURN    CAST(SUBSTRING(@str, @pos, CHARINDEX(@delim, @str + @delim, @pos) - @pos) AS INT)
END
GO
/****** Object:  UserDefinedFunction [dbo].[dnn_fn_GetVersion]    Script Date: 10/05/2007 21:33:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[dnn_fn_GetVersion]
(
	@maj AS int,
	@min AS int,
	@bld AS int
)
RETURNS bit

AS
BEGIN
	IF Exists (SELECT * FROM dnn_Version
					WHERE Major = @maj
						AND Minor = @min
						AND Build = @bld
				)
		BEGIN
			RETURN 1
		END
	RETURN 0
END
GO
/****** Object:  UserDefinedFunction [dbo].[dnn_GetProfilePropertyDefinitionID]    Script Date: 10/05/2007 21:33:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[dnn_GetProfilePropertyDefinitionID]
(
	@PortalID				int,
	@PropertyName			nvarchar(50)
)
RETURNS int

AS
BEGIN
	DECLARE @DefinitionID int
	SELECT @DefinitionID = -1

	IF  @PropertyName IS NULL
		OR LEN(@PropertyName) = 0
		RETURN -1

	IF @PortalID IS NULL
		SET @POrtalID = -1

	SET @DefinitionID = (SELECT PropertyDefinitionID 
							FROM dnn_ProfilePropertyDefinition
							WHERE PortalID = @PortalID
								AND PropertyName = @PropertyName
						)
	
	RETURN @DefinitionID
END
GO
/****** Object:  UserDefinedFunction [dbo].[dnn_GetProfileElement]    Script Date: 10/05/2007 21:33:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[dnn_GetProfileElement]
(
	@fieldName AS NVARCHAR(100),
	@fields AS NVARCHAR(4000),
	@values AS NVARCHAR(4000)
)

RETURNS NVARCHAR(4000)

AS

BEGIN

	-- If input is invalid, return null.
	IF  @fieldName IS NULL
		OR LEN(@fieldName) = 0
		OR @fields IS NULL
		OR LEN(@fields) = 0
		OR @values IS NULL
		OR LEN(@values) = 0
		RETURN NULL

	-- locate FieldName in Fields
	DECLARE @fieldNameToken AS NVARCHAR(20)
	DECLARE @fieldNameStart AS INTEGER, @valueStart AS INTEGER, @valueLength AS INTEGER

	-- Only handle string type fields (:S:)
	SET @fieldNameStart = CHARINDEX(@fieldName + ':S',@Fields,0)

	-- If field is not found, return null
	IF @fieldNameStart = 0 RETURN NULL
	SET @fieldNameStart = @fieldNameStart + LEN(@fieldName) + 3

	-- Get the field token which I've defined as the start of the field offset to the end of the length
	SET @fieldNameToken =
	SUBSTRING(@Fields,@fieldNameStart,LEN(@Fields)-@fieldNameStart)

	-- Get the values for the offset and length
	SET @valueStart = dbo.dnn_getelement(1,@fieldNameToken,':')
	SET @valueLength = dbo.dnn_getelement(2,@fieldNameToken,':')

	-- Check for sane values, 0 length means the profile item was stored, just no data
	IF @valueLength = 0 RETURN ''

	-- Return the string
	RETURN SUBSTRING(@values, @valueStart+1, @valueLength)
END
GO
