DATA SEGMENT
                
    MSG_EASYMAZE    	DB "---------------------------------------------|", 0AH, 0DH
						DB "   |              |        |     |     |     |", 0AH, 0DH
						DB "|  |------------  |---  |  |  |  |  |  |  |  |", 0AH, 0DH
						DB "|  |        |           |  |  |     |  |  |  |", 0AH, 0DH
						DB "|  |--|  ---|  |--|-----|  |------  |  |--|  |", 0AH, 0DH  
						DB "|     |        |  |     |--|        |        |", 0AH, 0DH  
						DB "|---  |  |-----|     |        ------|  ------|", 0AH, 0DH
						DB "|        |        |  |  |--|        |     |  |", 0AH, 0DH
						DB "|  ------|  ------|  |--|  |  |---  |---  |  |", 0AH, 0DH
						DB "|                 |           |     |        A", 0AH, 0DH
						DB "|--------------------------------------------|$"  
                    

           
    NEW_LINE         DB 13,10,"$"

    MSG_WON          DB "   You Have Won!  $",10,13

    x                DB 0H 
    y                DB 0H 
    NextX            DB 0H 
    NextY            DB 0H 
    position         DB 0H 
    dirInput         DB 0H                                             

    player           DB 0CH 

    
   
    
ENDS

STACK SEGMENT
	DW 128 DUP(0)
ENDS                          

CODE SEGMENT

    START:
	    MOV AX, DATA
	    MOV DS, AX
	    MOV ES, AX

    ;---------------------------------------------------------------------------------------------------- 
  
        
    GAME_START: 
        CALL EASYMAZE   
        CALL SET_STARTPOS 
        CALL PRINT_PLAYER
        JMP ChangePos
  
 
    ChangePos:    
        CALL GET_INPUT  
        MOV  dirInput, AL
       
        CMP  dirInput, 'W'
        JE   MOVE_NORTH
        CMP  dirInput, 'A'
        JE   MOVE_WEST
        CMP  dirInput, 'S'
        JE   MOVE_SOUTH
        CMP  dirInput, 'D'
        JE   MOVE_EAST  
        
   
    SHOW:
	    MOV AH, 09H 
	    INT 21H
	    RET
	    
	
	SHOW_CHARACTER:
	    MOV AH, 02H  
	    INT 21H
	    RET
	  
    CLEAN_SCREEN:
        MOV  AL, 3H ;
        MOV  AH, 0H
        INT  10H
        RET    
                           
    EASYMAZE:
        LEA  DX, MSG_EASYMAZE
        CALL SHOW 
        RET
       
   
    SET_STARTPOS:  
        MOV  NextX, 0H 
        MOV  NextY, 1H
        MOV  x, 0H
        MOV  y, 1H
        MOV  DL, x
        MOV  DH, y
        MOV  BH, 0H
        MOV  AH, 2H
        INT  10H
        RET
        
                      
    PRINT_PLAYER:      
        MOV  DL, player
        CALL SHOW_CHARACTER
        RET
   
    GET_INPUT: 
        MOV  AH, 7H
        INT  21H 
        RET
        
   
    SET_CURSOR:
        MOV  AH, 2H                                            
        INT  10H
        RET
        
  
    GET_CHARACTER:
        MOV  AL, 0h
        MOV  AH, 08h
        INT  10H
        RET
    
    READ_INPUT:
    	MOV AH, 01
    	INT 21H
    	RET
                                                                                                                    
    MOVE_NORTH:  
        CALL REMOVE_OLDPOS 
        DEC  NextY
        CALL ISVALID_POS
        DEC  y             
        MOV  DL, x                                          
        MOV  DH, y
        CALL SET_CURSOR
        CALL PRINT_PLAYER
        JMP  ChangePos     
             
                                 
                                                                  
    MOVE_SOUTH:  
        CALL REMOVE_OLDPOS
        INC  NextY                                           
        CALL ISVALID_POS
        INC  y                                         
        MOV  DL, x                                          
        MOV  DH, y    
        CALL SET_CURSOR
        CALL PRINT_PLAYER                                          
        JMP  ChangePos                                        
    
             
    MOVE_WEST: 
        CALL REMOVE_OLDPOS 
        DEC  NextX
        CALL ISVALID_POS
        DEC  x               
        MOV  DL, x                                          
        MOV  DH, y
        CALL SET_CURSOR
        CALL PRINT_PLAYER
        JMP  ChangePos     
                 
    MOVE_EAST:  
        CALL REMOVE_OLDPOS 
        INC  NextX
        CALL ISVALID_POS
        INC  x              
        MOV  DL, x
        MOV  DH, y
        CALL SET_CURSOR               
        CALL PRINT_PLAYER
        JMP  ChangePos    
        
    
    REMOVE_OLDPOS:
        MOV  DL, x                                          
        MOV  DH, y
        CALL SET_CURSOR                                             
        MOV  DL, ' '                                          
        CALL SHOW_CHARACTER
        RET
    
    
    ISVALID_POS:
        MOV  DL, NextX                                      
        MOV  DH, NextY
        CALL SET_CURSOR
        MOV  BH, 0h      
        CALL GET_CHARACTER 
        MOV  position, AL  
        CMP  position, ' '
        JNE  POS_NOTEMPTY
        RET

    POS_NOTEMPTY:                  
        CMP  position, 'A' 
        JE   WIN
        MOV  DL, x                                          
        MOV  DH, y
        CALL SET_CURSOR
        MOV  NextX, DL
        MOV  NextY, DH     
        CALL PRINT_PLAYER
        JMP  ChangePos     
                  
    WIN:         
        CALL CLEAN_SCREEN
        LEA  DX, MSG_WON

   EXIT_GAME:

        CALL SHOW
        CALL READ_INPUT
        JNE   EXIT
        
    EXIT:
        CALL CLEAN_SCREEN
        MOV  AX, 4C00H
        INT  21H
ENDS
END START
