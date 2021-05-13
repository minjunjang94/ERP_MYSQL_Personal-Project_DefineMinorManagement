drop PROCEDURE _SBDefineCMinor_Query;

DELIMITER $$
CREATE PROCEDURE _SBDefineCMinor_Query
	(
		 InData_CompanySeq			INT				-- 법인내부코드
		,InData_MinorName			VARCHAR(200)	-- Minor명
        ,InData_MajorName			VARCHAR(200)	-- Major명
		,Login_UserSeq				INT				-- 현재 로그인 중인 유저
    )
BEGIN    

	IF (InData_MinorName 	IS NULL OR InData_MinorName 	LIKE ''	) THEN	SET InData_MinorName 	= '%'; END IF;
	IF (InData_MajorName 	IS NULL OR InData_MajorName 	LIKE ''	) THEN	SET InData_MajorName 	= '%'; END IF;
    
    -- ---------------------------------------------------------------------------------------------------
    -- Query --
 
    set session transaction isolation level read uncommitted;  
    -- 최종조회 --
    SELECT 
		 A.CompanySeq				AS CompanySeq	
		,A.MinorName				AS MinorName	
		,A.MinorSeq					AS MinorSeq		
		,B.MajorName				AS MajorName	
		,B.MajorSeq					AS MajorSeq		
		,A.Value					AS Value		
		,A.MinorSort				AS MinorSort	
		,A.Remark					AS Remark		
		,C.UserName					AS LastUserName
		,C.UserSeq					AS LastUserSeq	
		,A.LastDateTime				AS LastDateTime
	FROM _TCBaseMinor 					AS A
    LEFT OUTER JOIN _TCBaseMajor 		AS B	ON B.CompanySeq 		= A.CompanySeq
											   AND B.MajorSeq    		= A.MajorSeq
	LEFT OUTER JOIN _TCBaseUser			AS C    ON C.CompanySeq			= A.CompanySeq
											   AND C.UserSeq		    = A.LastUserSeq
    WHERE A.CompanySeq    			=    InData_CompanySeq
      AND A.MinorName 				LIKE InData_MinorName
      AND B.MajorName 				LIKE InData_MajorName;

	set session transaction isolation level repeatable read;
    
END $$
DELIMITER ;