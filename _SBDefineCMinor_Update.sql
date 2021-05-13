drop PROCEDURE _SBDefineCMinor_Update;

DELIMITER $$
CREATE PROCEDURE _SBDefineCMinor_Update
	(
		 InData_OperateFlag		CHAR(2)			-- 작업표시
		,InData_CompanySeq		INT				-- 법인내부코드
		,InData_MajorName		VARCHAR(100)	-- Major명
		,InData_MinorName		VARCHAR(100)	-- (기존)Minor명
		,InData_ChgMinorName	VARCHAR(100)	-- (변경)Minor명
		,InData_Value			VARCHAR(60)		-- 값
		,InData_MinorSort		VARCHAR(60)		-- Sort순서
		,InData_Remark			VARCHAR(200)	-- 메모
		,Login_UserSeq			INT				-- 현재 로그인 중인 유저
    )
BEGIN

	-- 변수선언
    DECLARE Var_GetDateNow			VARCHAR(100);
    DECLARE Var_MajorSeq			INT;
	DECLARE Var_MinorSeq			INT;       
    
	SET Var_GetDateNow  = (SELECT DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i:%s") AS GetDate); -- 작업일시는 Update 되는 시점의 일시를 Insert
	SET Var_MajorSeq 	= (SELECT A.MajorSeq FROM _TCBaseMajor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MajorName = InData_MajorName);	
	SET Var_MinorSeq 	= (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_MinorName AND A.MajorSeq = Var_MajorSeq);    
    
    -- ---------------------------------------------------------------------------------------------------
    -- Update --
	IF( InData_OperateFlag = 'U' ) THEN     
			UPDATE _TCBaseMinor				AS A
			   SET	A.MinorName				= InData_ChgMinorName
				   ,A.Value					= InData_Value
				   ,A.MinorSort				= InData_MinorSort
				   ,A.Remark				= InData_Remark
				   ,A.LastUserSeq			= Login_UserSeq
				   ,A.LastDateTime			= Var_GetDateNow
			WHERE A.CompanySeq				= InData_CompanySeq 
			  AND A.MajorSeq				= Var_MajorSeq
			  AND A.MinorSeq				= Var_MinorSeq;  
                     
              SELECT '저장되었습니다.' AS Result; 
                     
	ELSE
			  SELECT '저장이 완료되지 않았습니다.' AS Result;
	END IF;	


END $$
DELIMITER ;