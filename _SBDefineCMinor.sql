drop PROCEDURE _SBDefineCMinor;

DELIMITER $$
CREATE PROCEDURE _SBDefineCMinor
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
    
    DECLARE State INT;
    
    -- ---------------------------------------------------------------------------------------------------
    -- Check --
	call _SBDefineCMinor_Check
		(
			 InData_OperateFlag		
			,InData_CompanySeq		
			,InData_MajorName		
			,InData_MinorName		
			,InData_ChgMinorName	
			,InData_Value			
			,InData_MinorSort		
			,InData_Remark			
			,Login_UserSeq				
			,@Error_Check
		);
    

	IF( @Error_Check = (SELECT 9999) ) THEN
		
        SET State = 9999; -- Error 발생
        
	ELSE

	    SET State = 1111; -- 정상작동
        
		-- ---------------------------------------------------------------------------------------------------
		-- Save --
		IF( (InData_OperateFlag = 'S' OR InData_OperateFlag = 'D') AND STATE = 1111 ) THEN
			call _SBDefineCMinor_Save
				(
					 InData_OperateFlag		
					,InData_CompanySeq		
					,InData_MajorName		
					,InData_MinorName	
					,InData_ChgMinorName	
					,InData_Value			
					,InData_MinorSort		
					,InData_Remark			
					,Login_UserSeq			
				);
		END IF;	
    
		-- ---------------------------------------------------------------------------------------------------
		-- Update --
		IF( InData_OperateFlag = 'U' AND STATE = 1111 ) THEN
			call _SBDefineCMinor_Update
				(
					 InData_OperateFlag		
					,InData_CompanySeq		
					,InData_MajorName		
					,InData_MinorName	
					,InData_ChgMinorName	
					,InData_Value			
					,InData_MinorSort		
					,InData_Remark			
					,Login_UserSeq			
				);		
		END IF;	    

	END IF;
END $$
DELIMITER ;