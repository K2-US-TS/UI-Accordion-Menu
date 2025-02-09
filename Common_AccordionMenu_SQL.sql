/****** Object:  Table [dbo].[AccordionMenuConfig]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccordionMenuConfig](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MenuName] [nvarchar](100) NULL,
	[MenuKey] [nvarchar](50) NULL,
	[MenuTitleBgColor] [nvarchar](50) NULL,
	[MenuTitleBorderColor] [nvarchar](50) NULL,
	[MenuBgColor] [nvarchar](50) NULL,
	[MenuFontColor] [nvarchar](50) NULL,
	[MenuTitleFontColor] [nvarchar](50) NULL,
	[MenuBgColorGradientStart] [nvarchar](50) NULL,
	[MenuBgColorGradientEnd] [nvarchar](50) NULL,
	[MenuHoverBgColor] [nvarchar](50) NULL,
	[MenuHoverFontColor] [nvarchar](50) NULL,
	[MenuSelectedFontColor] [nvarchar](50) NULL,
	[MenuSelectedBorderWidth] [nvarchar](50) NULL,
	[MenuTitleFontSize] [nvarchar](50) NULL,
	[MenuTitleLineHeight] [nvarchar](50) NULL,
	[MenuItemFontSize] [nvarchar](50) NULL,
	[MenuItemLineHeight] [nvarchar](50) NULL,
	[MenuIconSize] [nvarchar](50) NULL,
 CONSTRAINT [PK_AccordionMenuConfig] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccordionMenuItem]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccordionMenuItem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccordionMenuConfigID] [int] NULL,
	[ParentMenuItemID] [int] NULL,
	[MenuLevel] [nvarchar](10) NULL,
	[Icon] [nvarchar](255) NULL,
	[Caption] [nvarchar](100) NULL,
	[Link] [nvarchar](2048) NULL,
	[IsNewWindow] [bit] NULL,
	[Ordinal] [int] NULL,
	[MenuItemKey] [nvarchar](50) NULL,
 CONSTRAINT [PK_AccordionMenuItem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccordionMenuSupport]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccordionMenuSupport](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StylesCSS] [nvarchar](max) NULL,
	[Scripts] [nvarchar](max) NULL,
 CONSTRAINT [PK_AccordionMenuSupport] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AccordionMenu_Delete]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[AccordionMenu_Delete]
	 @pID int

as

/*** TESITNG

declare  @pID int = 2

exec dbo.AccordionMenu_Delete @pID


***/


DELETE 
FROM [dbo].[AccordionMenuItem]
WHERE AccordionMenuConfigID = @pID

DELETE
FROM [dbo].[AccordionMenuConfig]
WHERE [ID] = @pID
GO
/****** Object:  StoredProcedure [dbo].[AccordionMenu_DeleteSection]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AccordionMenu_DeleteSection]
	 @pID int

as

/*** TESITNG

declare  @pID int = 2

exec dbo.AccordionMenu_DeleteSection @pID


***/


DELETE 
FROM [dbo].[AccordionMenuItem]
WHERE ParentMenuItemID = @pID

DELETE
FROM [dbo].[AccordionMenuItem]
WHERE [ID] = @pID
GO
/****** Object:  StoredProcedure [dbo].[AccordionMenuConfig_Clone]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AccordionMenuConfig_Clone]
	 @pIDtoClone int

as


/*** TESTING

declare @pIDtoClone int = 1

exec dbo.AccordionMenuConfig_Clone @pIDtoClone

***/


INSERT INTO [dbo].[AccordionMenuConfig]
SELECT
       'COPY of ' + [MenuName]
	  ,NULL as [MenuKey]
      ,[MenuTitleBgColor]
      ,[MenuTitleBorderColor]
      ,[MenuBgColor]
      ,[MenuFontColor]
      ,[MenuTitleFontColor]
      ,[MenuBgColorGradientStart]
      ,[MenuBgColorGradientEnd]
      ,[MenuHoverBgColor]
      ,[MenuHoverFontColor]
      ,[MenuSelectedFontColor]
      ,[MenuSelectedBorderWidth]
      ,[MenuTitleFontSize]
      ,[MenuTitleLineHeight]
      ,[MenuItemFontSize]
      ,[MenuItemLineHeight]
      ,[MenuIconSize]
FROM [dbo].[AccordionMenuConfig]
WHERE [ID] = @pIDtoClone

SELECT @@IDENTITY as [ID]


GO
/****** Object:  StoredProcedure [dbo].[AccordionMenuHTML]    Script Date: 10/27/2020 11:25:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AccordionMenuHTML]
	 @pMenuKey nvarchar(50)
	,@pPositionTop int
	,@pMenuWidth int

as

/***  TESTING

declare @pMenuKey nvarchar(50) = 'Safety.Inspection'
       ,@pPositionTop int = 50
	   ,@pMenuWidth int = 200

exec dbo.AccordionMenuHTML @pMenuKey, @pPositionTop, @pMenuWidth

***/

declare @CRLF nvarchar(1) = CHAR(10)

declare @HTML nvarchar(max) = ''
declare @CSSVars nvarchar(max)
declare @CSS nvarchar(max)
declare @script nvarchar(max)

declare @sectionIndex int = 1
declare @menuItemIndex int = 1
declare @elementID nvarchar(50)

-- HTML element template variables
declare @sectionHeaderTemplate nvarchar(max) = N'<li><h3 class="itemtitle"><a id="{sectionID}" {href} {data-key} {data-link} {onclick}><span><i class="headerIcon fa {headerIcon}"></i></span>{caption}</a></h3>{menuItemsList}</li>'
declare @menuItemTemplate nvarchar(max) = N'<li><a id="{menuItemID}" {href} {data-key} {data-link} {onclick}>{caption}</a></li>'

-- HTML variables
declare @sectionHTML nvarchar(max) = ''
declare @menuItemsHTML nvarchar(max)

-- Menu Configuration variables
declare @menuTitleBgColor nvarchar(50)
       ,@menuTitleBorderColor nvarchar(50)
       ,@menuBgColor nvarchar(50)
       ,@menuFontColor nvarchar(50)
       ,@menuTitleFontColor nvarchar(50)
       ,@menuBgColorGradientStart nvarchar(50)
       ,@menuBgColorGradientEnd nvarchar(50)
       ,@menuHoverBgColor nvarchar(50)
       ,@menuHoverFontColor nvarchar(50)
       ,@menuSelectedFontColor nvarchar(50)
       ,@menuSelectedBorderWidth nvarchar(50)
       ,@menuTitleFontSize nvarchar(50)
       ,@menuTitleLineHeight nvarchar(50)
       ,@menuItemFontSize nvarchar(50)
       ,@menuItemLineHeight nvarchar(50)
       ,@menuIconSize nvarchar(50)
	   ,@ConfigID int

-- Menu Item cursor variables
declare @sectionID int
       ,@icon nvarchar(50)
       ,@caption nvarchar(100)
	   ,@link nvarchar(2048)
	   ,@isNewWindow bit
	   ,@MenuItemKey nvarchar(50)

-- Load Menu Configuration variables
SELECT 
	 @ConfigID				   = [ID]
	,@menuTitleBgColor         = [MenuTitleBgColor]        
	,@menuTitleBorderColor     = [MenuTitleBorderColor]                           
	,@menuBgColor              = [MenuBgColor]                                    
	,@menuFontColor            = [MenuFontColor]                                  
	,@menuTitleFontColor       = [MenuTitleFontColor]                             
	,@menuBgColorGradientStart = [MenuBgColorGradientStart]                       
	,@menuBgColorGradientEnd   = [MenuBgColorGradientEnd]                         
	,@menuHoverBgColor         = [MenuHoverBgColor]                               
	,@menuHoverFontColor       = [MenuHoverFontColor]                             
	,@menuSelectedFontColor    = [MenuSelectedFontColor]                          
	,@menuSelectedBorderWidth  = [MenuSelectedBorderWidth]                        
	,@menuTitleFontSize        = [MenuTitleFontSize]                              
	,@menuTitleLineHeight      = [MenuTitleLineHeight]                            
	,@menuItemFontSize         = [MenuItemFontSize]                               
	,@menuItemLineHeight       = [MenuItemLineHeight]                             
	,@menuIconSize             = [MenuIconSize]
FROM [dbo].[AccordionMenuConfig]
WHERE [MenuKey] = @pMenuKey

-- Set CSS variables based on configuration
SET @CSSVars = N'
<style>

	:root {
		--menu-title-bgColor: ' + @menuTitleBgColor + ';
		--menu-title-border-color: ' + @menuTitleBorderColor + ';
  		--menu-bgColor: ' + @menuBgColor + ';
  		--menu-font-color: ' + @menuFontColor + ';
  		--menu-title-font-color: ' + @menuTitleFontColor + ';
  		--menu-bgColor-gradient-start: ' + @menuBgColorGradientStart + ';
  		--menu-bgColor-gradient-end: ' + @menuBgColorGradientEnd + ';
  		--menu-hover-bgColor: ' + @menuHoverBgColor + ';
  		--menu-hover-font-color: ' + @menuHoverFontColor + ';
  		--menu-selected-font-color: ' + @menuSelectedFontColor + ';
  		--menu-selected-border-width: ' + @menuSelectedBorderWidth + ';
  		--menu-title-font-size: ' + @menuTitleFontSize + ';
  		--menu-title-line-height: ' + @menuTitleLineHeight + ';
  		--menu-item-line-height: ' + @menuItemLineHeight + ';
  		--menu-item-font-size: ' + @menuItemFontSize + ';
        --menu-width: ' + CONVERT(NVARCHAR(50), @pMenuWidth) + 'px;
	}
</style>
'

-- Get addditional CSS
SELECT @CSS = StylesCSS
FROM [dbo].[AccordionMenuSupport]
WHERE ID = 1

SET @CSS = @CSSVars + @CSS

-- Set the script variable
SELECT @script = Scripts
FROM [dbo].[AccordionMenuSupport]
WHERE ID = 1

-- Set script replacement tag
SET @script = REPLACE(@script, '{PositionTop}', CONVERT(NVARCHAR(10), @pPositionTop))
SET @script = REPLACE(@script, '{MenuWidth}', CONVERT(NVARCHAR(10), @pMenuWidth))

---------------------
-- MAIN PROCESSING --
---------------------

-- Section cursor
DECLARE curSection CURSOR FAST_FORWARD FOR
SELECT ID, Icon, Caption, ISNULL(Link, '') as Link, IsNewWindow, MenuItemKey
FROM [dbo].[AccordionMenuItem]
WHERE MenuLevel = 'Section'
  AND AccordionMenuConfigID = @ConfigID
ORDER BY Ordinal

OPEN curSection

FETCH NEXT FROM curSection 
INTO @sectionID, @icon, @caption, @link, @isNewWindow, @MenuItemKey

-- Section processing
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @sectionHTML = @sectionHeaderTemplate
	SET @elementID = 'menuHeader' + CONVERT(NVARCHAR(10), @sectionIndex)

	SET @sectionHTML = REPLACE(@sectionHTML, '{sectionID}', @elementID)
	SET @sectionHTML = REPLACE(@sectionHTML, '{headerIcon}', @icon)
	SET @sectionHTML = REPLACE(@sectionHTML, '{caption}', @caption)
	
	IF (ISNULL(@MenuItemKey, '') <> '') BEGIN
		SET @sectionHTML = REPLACE(@sectionHTML, '{data-key}', 'data-key="' + @MenuItemKey + '"')
	END
	ELSE BEGIN
		SET @sectionHTML = REPLACE(@sectionHTML, '{data-key}', '')
	END

	IF (ISNULL(@link, '') <> '') BEGIN
		SET @sectionHTML = REPLACE(@sectionHTML, '{data-link}', 'data-link="' + @link + '"')
		IF (@isNewWindow = 1) BEGIN
			SET @sectionHTML = REPLACE(@sectionHTML, '{href}', 'href="' + @link + '" target="_new"')
			SET @sectionHTML = REPLACE(@sectionHTML, '{onclick}', '')
		END 
		ELSE BEGIN
			SET @sectionHTML = REPLACE(@sectionHTML, '{href}', 'href="#"')
			SET @sectionHTML = REPLACE(@sectionHTML, '{onclick}', 'onclick="menuHeaderClick(this); menuItemClick(this)"')
		END
	END
	ELSE BEGIN
		SET @sectionHTML = REPLACE(@sectionHTML, '{href}', 'href="#"')
		SET @sectionHTML = REPLACE(@sectionHTML, '{onclick}', 'onclick="menuHeaderClick(this)"')
 		SET @sectionHTML = REPLACE(@sectionHTML, '{data-link}', '')
	END

	set @sectionHTML = @sectionHTML + @CRLF

	-- Menu items cursor
	DECLARE curMenuItem CURSOR FAST_FORWARD FOR
	SELECT Icon, Caption, ISNULL(Link, '') as Link, IsNewWindow, MenuItemKey
	FROM [dbo].[AccordionMenuItem]
	WHERE ParentMenuItemID = @sectionID
	ORDER BY Ordinal

	OPEN curMenuItem

	-- Menu items processing
	FETCH NEXT FROM curMenuItem
	INTO @icon, @caption, @link, @isNewWindow, @MenuItemKey
	
	SET @menuItemIndex = 1
	SET @menuItemsHTML = ''

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF (@menuItemsHTML = '') BEGIN
			SET @menuItemsHTML = '<ul>'
		END

		SET @menuItemsHTML = @menuItemsHTML + @menuItemTemplate

		SET @elementID = 'menuItem' + CONVERT(NVARCHAR(10), @sectionIndex) + '_' + CONVERT(NVARCHAR(10), @menuItemIndex)

		SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{menuItemID}', @elementID)
		SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{caption}', @caption)

		IF (ISNULL(@MenuItemKey, '') <> '') BEGIN
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{data-key}', 'data-key="' + @MenuItemKey + '"')
		END
		ELSE BEGIN
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{data-key}', '')
		END

		IF (ISNULL(@link, '') <> '') BEGIN
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{data-link}', 'data-link="' + @link + '"')
		END
		ELSE BEGIN
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{data-link}', '')
		END

		IF (@isNewWindow = 1) BEGIN
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{href}', 'href="' + @link + '" target="_new"')
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{onclick}', '')
		END 
		ELSE BEGIN
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{href}', 'href="#"')
			SET @menuItemsHTML = REPLACE(@menuItemsHTML, '{onclick}', 'onclick="menuItemClick(this)"')
		END

		FETCH NEXT FROM curMenuItem
		INTO @icon, @caption, @link, @isNewWindow, @MenuItemKey

		SET @menuItemsHTML = @menuItemsHTML + @CRLF

		SET @menuItemIndex = @menuItemIndex + 1

	END

	IF (@menuItemsHTML <> '') BEGIN
		SET @menuItemsHTML = @menuItemsHTML + '</ul>'
	END

	SET @sectionHTML = REPLACE(@sectionHTML, '{menuItemsList}', @menuItemsHTML)
	SET @HTML = @HTML + @sectionHTML

	CLOSE curMenuItem
	DEALLOCATE curMenuItem
	
	FETCH NEXT FROM curSection 
	INTO @sectionID, @icon, @caption, @link, @isNewWindow, @MenuItemKey

	SET @sectionIndex = @sectionIndex + 1

END

CLOSE curSection
DEALLOCATE curSection


-- Set and return the FINAL HTML
SET @HTML = @CSS + '<div id="accordion" style="position:fixed; overflow-y:auto; top:' + convert(nvarchar(50), @pPositionTop) + 'px; height:100%"><ul>' + @CRLF + @HTML + '</ul></div>' + @CRLF + @script

-- K2 requires a table to be selected for output
DECLARE @tblHTML TABLE (
	HTML nvarchar(max)
)

INSERT INTO @tblHTML
SELECT @HTML

SELECT HTML FROM @tblHTML

GO
