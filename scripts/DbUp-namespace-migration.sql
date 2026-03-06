DECLARE @OldScriptName NVARCHAR(MAX)

DECLARE cur CURSOR FOR
    SELECT ScriptName
    FROM SchemaVersions;

DECLARE @NewScriptNames TABLE
                        (
                            Name NVARCHAR(MAX),
                            Applied DATETIME
                        )

OPEN cur;

FETCH NEXT FROM cur INTO @OldScriptName;

WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @ScriptName NVARCHAR(MAX),
            @TotalSubstrings INT;

        DECLARE @Substrings TABLE
                            (
                                PartIndex INT IDENTITY (1,1),
                                Substring NVARCHAR(MAX)
                            );

        INSERT INTO @Substrings (Substring)
        SELECT value
        FROM STRING_SPLIT(@OldScriptName, '.');

        SET @TotalSubstrings = (SELECT COUNT(*) FROM @Substrings);
        SELECT @ScriptName = Substring FROM @Substrings WHERE PartIndex = @TotalSubstrings - 1;

        SET @OldScriptName = 'OldName.' + @ScriptName + '.sql';
        PRINT @OldScriptName;

        INSERT INTO @NewScriptNames VALUES (@OldScriptName, GETUTCDATE());

        FETCH NEXT FROM cur INTO @OldScriptName
    END

CLOSE cur;
DEALLOCATE cur;

INSERT INTO [dbo].[SchemaVersions] (ScriptName, Applied)
SELECT Name, Applied FROM @NewScriptNames;
