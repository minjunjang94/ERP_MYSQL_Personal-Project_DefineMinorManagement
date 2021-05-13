drop PROCEDURE _SBDefineCMinor_Save;

DELIMITER $$
CREATE PROCEDURE _SBDefineCMinor_Save
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
    DECLARE Var_MajorSeq			INT;
    DECLARE Var_GetDateNow			VARCHAR(100);
    DECLARE Var_MinorSeqSetValue	INT;
    DECLARE Var_MinorSeqMAX			INT;       
    DECLARE Var_InsertMinorSeq		INT;   
	DECLARE Var_MinorSeq			INT;   
    
	SET Var_MajorSeq 			= (SELECT A.MajorSeq FROM _TCBaseMajor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MajorName = InData_MajorName);	
	SET Var_GetDateNow  		= (SELECT DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i:%s") AS GetDate); -- 작업일시는 Save되는 시점의 일시를 Insert
	SET Var_MinorSeqSetValue    = (SELECT CONCAT(CAST(Var_MajorSeq as char(10)),'','000')); -- MinorSeq의 셋팅값
	SET Var_MinorSeqMAX			= (SELECT MAX(A.MinorSeq) AS MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MajorSeq = Var_MajorSeq);

	/*MinorSeq 채번*/
	 IF (Var_MinorSeqMAX IS NOT NULL) THEN 
		SET Var_InsertMinorSeq = Var_MinorSeqMAX + 1;		
     ELSE 
		SET Var_InsertMinorSeq = Var_MinorSeqSetValue + 1;	
     END IF;

    -- ---------------------------------------------------------------------------------------------------
    -- Insert --
	IF( InData_OperateFlag = 'S' ) THEN
		INSERT INTO _TCBaseMinor 
		( 	 
			 CompanySeq		-- 법인내부코드
			,MinorSeq		-- Minor Seq
			,MajorSeq		-- Major Seq
			,MinorName		-- Minor 명
			,Value			-- 값
			,MinorSort		-- Sort순서
			,Remark			-- 메모
			,LastUserSeq	-- 작업자
			,LastDateTime	-- 작업일시            
        )
		VALUES
		(
			 InData_CompanySeq		
			,Var_InsertMinorSeq		
			,Var_MajorSeq		
			,InData_MinorName		
			,InData_Value			
			,InData_MinorSort		
			,InData_Remark			
			,Login_UserSeq	
			,Var_GetDateNow		
		);
        
        SELECT '저장이 완료되었습니다' AS Result;

	-- ---------------------------------------------------------------------------------------------------        
    -- Delete --
	ELSEIF ( InData_OperateFlag = 'D' ) THEN  
    
		SET Var_MinorSeq = (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_MinorName AND A.MajorSeq = Var_MajorSeq);  
        
		DELETE FROM _TCBaseMinor 	WHERE CompanySeq = InData_CompanySeq AND MinorSeq = Var_MinorSeq AND MajorSeq = Var_MajorSeq;

        SELECT '삭제되었습니다.' AS Result; 
        
	END IF;	
    
END $$
DELIMITER ;