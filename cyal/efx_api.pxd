from . cimport al

cdef extern from "efx.h":
    cdef enum:
        ALC_EXT_EFX_NAME

        ALC_EFX_MAJOR_VERSION                   
        ALC_EFX_MINOR_VERSION                   
        ALC_MAX_AUXILIARY_SENDS                 


        # Listener properties. 
        AL_METERS_PER_UNIT                      

        # Source properties. 
        AL_DIRECT_FILTER                        
        AL_AUXILIARY_SEND_FILTER                
        AL_AIR_ABSORPTION_FACTOR                
        AL_ROOM_ROLLOFF_FACTOR                  
        AL_CONE_OUTER_GAINHF                    
        AL_DIRECT_FILTER_GAINHF_AUTO            
        AL_AUXILIARY_SEND_FILTER_GAIN_AUTO      
        AL_AUXILIARY_SEND_FILTER_GAINHF_AUTO    


        # Effect properties. 

        # Reverb effect parameters 
        AL_REVERB_DENSITY                       
        AL_REVERB_DIFFUSION                     
        AL_REVERB_GAIN                          
        AL_REVERB_GAINHF                        
        AL_REVERB_DECAY_TIME                    
        AL_REVERB_DECAY_HFRATIO                 
        AL_REVERB_REFLECTIONS_GAIN              
        AL_REVERB_REFLECTIONS_DELAY             
        AL_REVERB_LATE_REVERB_GAIN              
        AL_REVERB_LATE_REVERB_DELAY             
        AL_REVERB_AIR_ABSORPTION_GAINHF         
        AL_REVERB_ROOM_ROLLOFF_FACTOR           
        AL_REVERB_DECAY_HFLIMIT                 

        # EAX Reverb effect parameters 
        AL_EAXREVERB_DENSITY                    
        AL_EAXREVERB_DIFFUSION                  
        AL_EAXREVERB_GAIN                       
        AL_EAXREVERB_GAINHF                     
        AL_EAXREVERB_GAINLF                     
        AL_EAXREVERB_DECAY_TIME                 
        AL_EAXREVERB_DECAY_HFRATIO              
        AL_EAXREVERB_DECAY_LFRATIO              
        AL_EAXREVERB_REFLECTIONS_GAIN           
        AL_EAXREVERB_REFLECTIONS_DELAY          
        AL_EAXREVERB_REFLECTIONS_PAN            
        AL_EAXREVERB_LATE_REVERB_GAIN           
        AL_EAXREVERB_LATE_REVERB_DELAY          
        AL_EAXREVERB_LATE_REVERB_PAN            
        AL_EAXREVERB_ECHO_TIME                  
        AL_EAXREVERB_ECHO_DEPTH                 
        AL_EAXREVERB_MODULATION_TIME            
        AL_EAXREVERB_MODULATION_DEPTH           
        AL_EAXREVERB_AIR_ABSORPTION_GAINHF      
        AL_EAXREVERB_HFREFERENCE                
        AL_EAXREVERB_LFREFERENCE                
        AL_EAXREVERB_ROOM_ROLLOFF_FACTOR        
        AL_EAXREVERB_DECAY_HFLIMIT              

        # Chorus effect parameters 
        AL_CHORUS_WAVEFORM                      
        AL_CHORUS_PHASE                         
        AL_CHORUS_RATE                          
        AL_CHORUS_DEPTH                         
        AL_CHORUS_FEEDBACK                      
        AL_CHORUS_DELAY                         

        # Distortion effect parameters 
        AL_DISTORTION_EDGE                      
        AL_DISTORTION_GAIN                      
        AL_DISTORTION_LOWPASS_CUTOFF            
        AL_DISTORTION_EQCENTER                  
        AL_DISTORTION_EQBANDWIDTH               

        # Echo effect parameters 
        AL_ECHO_DELAY                           
        AL_ECHO_LRDELAY                         
        AL_ECHO_DAMPING                         
        AL_ECHO_FEEDBACK                        
        AL_ECHO_SPREAD                          

        # Flanger effect parameters 
        AL_FLANGER_WAVEFORM                     
        AL_FLANGER_PHASE                        
        AL_FLANGER_RATE                         
        AL_FLANGER_DEPTH                        
        AL_FLANGER_FEEDBACK                     
        AL_FLANGER_DELAY                        

        # Frequency shifter effect parameters 
        AL_FREQUENCY_SHIFTER_FREQUENCY          
        AL_FREQUENCY_SHIFTER_LEFT_DIRECTION     
        AL_FREQUENCY_SHIFTER_RIGHT_DIRECTION    

        # Vocal morpher effect parameters 
        AL_VOCAL_MORPHER_PHONEMEA               
        AL_VOCAL_MORPHER_PHONEMEA_COARSE_TUNING 
        AL_VOCAL_MORPHER_PHONEMEB               
        AL_VOCAL_MORPHER_PHONEMEB_COARSE_TUNING 
        AL_VOCAL_MORPHER_WAVEFORM               
        AL_VOCAL_MORPHER_RATE                   

        # Pitchshifter effect parameters 
        AL_PITCH_SHIFTER_COARSE_TUNE            
        AL_PITCH_SHIFTER_FINE_TUNE              

        # Ringmodulator effect parameters 
        AL_RING_MODULATOR_FREQUENCY             
        AL_RING_MODULATOR_HIGHPASS_CUTOFF       
        AL_RING_MODULATOR_WAVEFORM              

        # Autowah effect parameters 
        AL_AUTOWAH_ATTACK_TIME                  
        AL_AUTOWAH_RELEASE_TIME                 
        AL_AUTOWAH_RESONANCE                    
        AL_AUTOWAH_PEAK_GAIN                    

        # Compressor effect parameters 
        AL_COMPRESSOR_ONOFF                     

        # Equalizer effect parameters 
        AL_EQUALIZER_LOW_GAIN                   
        AL_EQUALIZER_LOW_CUTOFF                 
        AL_EQUALIZER_MID1_GAIN                  
        AL_EQUALIZER_MID1_CENTER                
        AL_EQUALIZER_MID1_WIDTH                 
        AL_EQUALIZER_MID2_GAIN                  
        AL_EQUALIZER_MID2_CENTER                
        AL_EQUALIZER_MID2_WIDTH                 
        AL_EQUALIZER_HIGH_GAIN                  
        AL_EQUALIZER_HIGH_CUTOFF                

        # Effect type 
        AL_EFFECT_FIRST_PARAMETER               
        AL_EFFECT_LAST_PARAMETER                
        AL_EFFECT_TYPE                          

        # Effect types, used with the AL_EFFECT_TYPE property 
        AL_EFFECT_NULL                          
        AL_EFFECT_REVERB                        
        AL_EFFECT_CHORUS                        
        AL_EFFECT_DISTORTION                    
        AL_EFFECT_ECHO                          
        AL_EFFECT_FLANGER                       
        AL_EFFECT_FREQUENCY_SHIFTER             
        AL_EFFECT_VOCAL_MORPHER                 
        AL_EFFECT_PITCH_SHIFTER                 
        AL_EFFECT_RING_MODULATOR                
        AL_EFFECT_AUTOWAH                       
        AL_EFFECT_COMPRESSOR                    
        AL_EFFECT_EQUALIZER                     
        AL_EFFECT_EAXREVERB                     

        # Auxiliary Effect Slot properties. 
        AL_EFFECTSLOT_EFFECT                    
        AL_EFFECTSLOT_GAIN                      
        AL_EFFECTSLOT_AUXILIARY_SEND_AUTO       

        # NULL Auxiliary Slot ID to disable a source send. 
        AL_EFFECTSLOT_NULL                      


        # Filter properties. 

        # Lowpass filter parameters 
        AL_LOWPASS_GAIN                         
        AL_LOWPASS_GAINHF                       

        # Highpass filter parameters 
        AL_HIGHPASS_GAIN                        
        AL_HIGHPASS_GAINLF                      

        # Bandpass filter parameters 
        AL_BANDPASS_GAIN                        
        AL_BANDPASS_GAINLF                      
        AL_BANDPASS_GAINHF                      

        # Filter type 
        AL_FILTER_FIRST_PARAMETER               
        AL_FILTER_LAST_PARAMETER                
        AL_FILTER_TYPE                          

        # Filter types, used with the AL_FILTER_TYPE property 
        AL_FILTER_NULL                          
        AL_FILTER_LOWPASS                       
        AL_FILTER_HIGHPASS                      
        AL_FILTER_BANDPASS                      

        # Filter ranges and defaults. 

        # Lowpass filter 
        AL_LOWPASS_MIN_GAIN                     
        AL_LOWPASS_MAX_GAIN                     
        AL_LOWPASS_DEFAULT_GAIN                 

        AL_LOWPASS_MIN_GAINHF                   
        AL_LOWPASS_MAX_GAINHF                   
        AL_LOWPASS_DEFAULT_GAINHF               

        # Highpass filter 
        AL_HIGHPASS_MIN_GAIN                    
        AL_HIGHPASS_MAX_GAIN                    
        AL_HIGHPASS_DEFAULT_GAIN                

        AL_HIGHPASS_MIN_GAINLF                  
        AL_HIGHPASS_MAX_GAINLF                  
        AL_HIGHPASS_DEFAULT_GAINLF              

        # Bandpass filter 
        AL_BANDPASS_MIN_GAIN                    
        AL_BANDPASS_MAX_GAIN                    
        AL_BANDPASS_DEFAULT_GAIN                

        AL_BANDPASS_MIN_GAINHF                  
        AL_BANDPASS_MAX_GAINHF                  
        AL_BANDPASS_DEFAULT_GAINHF              

        AL_BANDPASS_MIN_GAINLF                  
        AL_BANDPASS_MAX_GAINLF                  
        AL_BANDPASS_DEFAULT_GAINLF              


        # Effect parameter ranges and defaults. 

        # Standard reverb effect 
        AL_REVERB_MIN_DENSITY                   
        AL_REVERB_MAX_DENSITY                   
        AL_REVERB_DEFAULT_DENSITY               

        AL_REVERB_MIN_DIFFUSION                 
        AL_REVERB_MAX_DIFFUSION                 
        AL_REVERB_DEFAULT_DIFFUSION             

        AL_REVERB_MIN_GAIN                      
        AL_REVERB_MAX_GAIN                      
        AL_REVERB_DEFAULT_GAIN                  

        AL_REVERB_MIN_GAINHF                    
        AL_REVERB_MAX_GAINHF                    
        AL_REVERB_DEFAULT_GAINHF                

        AL_REVERB_MIN_DECAY_TIME                
        AL_REVERB_MAX_DECAY_TIME                
        AL_REVERB_DEFAULT_DECAY_TIME            

        AL_REVERB_MIN_DECAY_HFRATIO             
        AL_REVERB_MAX_DECAY_HFRATIO             
        AL_REVERB_DEFAULT_DECAY_HFRATIO         

        AL_REVERB_MIN_REFLECTIONS_GAIN          
        AL_REVERB_MAX_REFLECTIONS_GAIN          
        AL_REVERB_DEFAULT_REFLECTIONS_GAIN      

        AL_REVERB_MIN_REFLECTIONS_DELAY         
        AL_REVERB_MAX_REFLECTIONS_DELAY         
        AL_REVERB_DEFAULT_REFLECTIONS_DELAY     

        AL_REVERB_MIN_LATE_REVERB_GAIN          
        AL_REVERB_MAX_LATE_REVERB_GAIN          
        AL_REVERB_DEFAULT_LATE_REVERB_GAIN      

        AL_REVERB_MIN_LATE_REVERB_DELAY         
        AL_REVERB_MAX_LATE_REVERB_DELAY         
        AL_REVERB_DEFAULT_LATE_REVERB_DELAY     

        AL_REVERB_MIN_AIR_ABSORPTION_GAINHF     
        AL_REVERB_MAX_AIR_ABSORPTION_GAINHF     
        AL_REVERB_DEFAULT_AIR_ABSORPTION_GAINHF 

        AL_REVERB_MIN_ROOM_ROLLOFF_FACTOR       
        AL_REVERB_MAX_ROOM_ROLLOFF_FACTOR       
        AL_REVERB_DEFAULT_ROOM_ROLLOFF_FACTOR   

        AL_REVERB_MIN_DECAY_HFLIMIT             
        AL_REVERB_MAX_DECAY_HFLIMIT             
        AL_REVERB_DEFAULT_DECAY_HFLIMIT         

        # EAX reverb effect 
        AL_EAXREVERB_MIN_DENSITY                
        AL_EAXREVERB_MAX_DENSITY                
        AL_EAXREVERB_DEFAULT_DENSITY            

        AL_EAXREVERB_MIN_DIFFUSION              
        AL_EAXREVERB_MAX_DIFFUSION              
        AL_EAXREVERB_DEFAULT_DIFFUSION          

        AL_EAXREVERB_MIN_GAIN                   
        AL_EAXREVERB_MAX_GAIN                   
        AL_EAXREVERB_DEFAULT_GAIN               

        AL_EAXREVERB_MIN_GAINHF                 
        AL_EAXREVERB_MAX_GAINHF                 
        AL_EAXREVERB_DEFAULT_GAINHF             

        AL_EAXREVERB_MIN_GAINLF                 
        AL_EAXREVERB_MAX_GAINLF                 
        AL_EAXREVERB_DEFAULT_GAINLF             

        AL_EAXREVERB_MIN_DECAY_TIME             
        AL_EAXREVERB_MAX_DECAY_TIME             
        AL_EAXREVERB_DEFAULT_DECAY_TIME         

        AL_EAXREVERB_MIN_DECAY_HFRATIO          
        AL_EAXREVERB_MAX_DECAY_HFRATIO          
        AL_EAXREVERB_DEFAULT_DECAY_HFRATIO      

        AL_EAXREVERB_MIN_DECAY_LFRATIO          
        AL_EAXREVERB_MAX_DECAY_LFRATIO          
        AL_EAXREVERB_DEFAULT_DECAY_LFRATIO      

        AL_EAXREVERB_MIN_REFLECTIONS_GAIN       
        AL_EAXREVERB_MAX_REFLECTIONS_GAIN       
        AL_EAXREVERB_DEFAULT_REFLECTIONS_GAIN   

        AL_EAXREVERB_MIN_REFLECTIONS_DELAY      
        AL_EAXREVERB_MAX_REFLECTIONS_DELAY      
        AL_EAXREVERB_DEFAULT_REFLECTIONS_DELAY  

        AL_EAXREVERB_DEFAULT_REFLECTIONS_PAN_XYZ

        AL_EAXREVERB_MIN_LATE_REVERB_GAIN       
        AL_EAXREVERB_MAX_LATE_REVERB_GAIN       
        AL_EAXREVERB_DEFAULT_LATE_REVERB_GAIN   

        AL_EAXREVERB_MIN_LATE_REVERB_DELAY      
        AL_EAXREVERB_MAX_LATE_REVERB_DELAY      
        AL_EAXREVERB_DEFAULT_LATE_REVERB_DELAY  

        AL_EAXREVERB_DEFAULT_LATE_REVERB_PAN_XYZ

        AL_EAXREVERB_MIN_ECHO_TIME              
        AL_EAXREVERB_MAX_ECHO_TIME              
        AL_EAXREVERB_DEFAULT_ECHO_TIME          

        AL_EAXREVERB_MIN_ECHO_DEPTH             
        AL_EAXREVERB_MAX_ECHO_DEPTH             
        AL_EAXREVERB_DEFAULT_ECHO_DEPTH         

        AL_EAXREVERB_MIN_MODULATION_TIME        
        AL_EAXREVERB_MAX_MODULATION_TIME        
        AL_EAXREVERB_DEFAULT_MODULATION_TIME    

        AL_EAXREVERB_MIN_MODULATION_DEPTH       
        AL_EAXREVERB_MAX_MODULATION_DEPTH       
        AL_EAXREVERB_DEFAULT_MODULATION_DEPTH   

        AL_EAXREVERB_MIN_AIR_ABSORPTION_GAINHF  
        AL_EAXREVERB_MAX_AIR_ABSORPTION_GAINHF  
        AL_EAXREVERB_DEFAULT_AIR_ABSORPTION_GAINHF

        AL_EAXREVERB_MIN_HFREFERENCE            
        AL_EAXREVERB_MAX_HFREFERENCE            
        AL_EAXREVERB_DEFAULT_HFREFERENCE        

        AL_EAXREVERB_MIN_LFREFERENCE            
        AL_EAXREVERB_MAX_LFREFERENCE            
        AL_EAXREVERB_DEFAULT_LFREFERENCE        

        AL_EAXREVERB_MIN_ROOM_ROLLOFF_FACTOR    
        AL_EAXREVERB_MAX_ROOM_ROLLOFF_FACTOR    
        AL_EAXREVERB_DEFAULT_ROOM_ROLLOFF_FACTOR

        AL_EAXREVERB_MIN_DECAY_HFLIMIT          
        AL_EAXREVERB_MAX_DECAY_HFLIMIT          
        AL_EAXREVERB_DEFAULT_DECAY_HFLIMIT      

        # Chorus effect 
        AL_CHORUS_WAVEFORM_SINUSOID             
        AL_CHORUS_WAVEFORM_TRIANGLE             

        AL_CHORUS_MIN_WAVEFORM                  
        AL_CHORUS_MAX_WAVEFORM                  
        AL_CHORUS_DEFAULT_WAVEFORM              

        AL_CHORUS_MIN_PHASE                     
        AL_CHORUS_MAX_PHASE                     
        AL_CHORUS_DEFAULT_PHASE                 

        AL_CHORUS_MIN_RATE                      
        AL_CHORUS_MAX_RATE                      
        AL_CHORUS_DEFAULT_RATE                  

        AL_CHORUS_MIN_DEPTH                     
        AL_CHORUS_MAX_DEPTH                     
        AL_CHORUS_DEFAULT_DEPTH                 

        AL_CHORUS_MIN_FEEDBACK                  
        AL_CHORUS_MAX_FEEDBACK                  
        AL_CHORUS_DEFAULT_FEEDBACK              

        AL_CHORUS_MIN_DELAY                     
        AL_CHORUS_MAX_DELAY                     
        AL_CHORUS_DEFAULT_DELAY                 

        # Distortion effect 
        AL_DISTORTION_MIN_EDGE                  
        AL_DISTORTION_MAX_EDGE                  
        AL_DISTORTION_DEFAULT_EDGE              

        AL_DISTORTION_MIN_GAIN                  
        AL_DISTORTION_MAX_GAIN                  
        AL_DISTORTION_DEFAULT_GAIN              

        AL_DISTORTION_MIN_LOWPASS_CUTOFF        
        AL_DISTORTION_MAX_LOWPASS_CUTOFF        
        AL_DISTORTION_DEFAULT_LOWPASS_CUTOFF    

        AL_DISTORTION_MIN_EQCENTER              
        AL_DISTORTION_MAX_EQCENTER              
        AL_DISTORTION_DEFAULT_EQCENTER          

        AL_DISTORTION_MIN_EQBANDWIDTH           
        AL_DISTORTION_MAX_EQBANDWIDTH           
        AL_DISTORTION_DEFAULT_EQBANDWIDTH       

        # Echo effect 
        AL_ECHO_MIN_DELAY                       
        AL_ECHO_MAX_DELAY                       
        AL_ECHO_DEFAULT_DELAY                   

        AL_ECHO_MIN_LRDELAY                     
        AL_ECHO_MAX_LRDELAY                     
        AL_ECHO_DEFAULT_LRDELAY                 

        AL_ECHO_MIN_DAMPING                     
        AL_ECHO_MAX_DAMPING                     
        AL_ECHO_DEFAULT_DAMPING                 

        AL_ECHO_MIN_FEEDBACK                    
        AL_ECHO_MAX_FEEDBACK                    
        AL_ECHO_DEFAULT_FEEDBACK                

        AL_ECHO_MIN_SPREAD                      
        AL_ECHO_MAX_SPREAD                      
        AL_ECHO_DEFAULT_SPREAD                  

        # Flanger effect 
        AL_FLANGER_WAVEFORM_SINUSOID            
        AL_FLANGER_WAVEFORM_TRIANGLE            

        AL_FLANGER_MIN_WAVEFORM                 
        AL_FLANGER_MAX_WAVEFORM                 
        AL_FLANGER_DEFAULT_WAVEFORM             

        AL_FLANGER_MIN_PHASE                    
        AL_FLANGER_MAX_PHASE                    
        AL_FLANGER_DEFAULT_PHASE                

        AL_FLANGER_MIN_RATE                     
        AL_FLANGER_MAX_RATE                     
        AL_FLANGER_DEFAULT_RATE                 

        AL_FLANGER_MIN_DEPTH                    
        AL_FLANGER_MAX_DEPTH                    
        AL_FLANGER_DEFAULT_DEPTH                

        AL_FLANGER_MIN_FEEDBACK                 
        AL_FLANGER_MAX_FEEDBACK                 
        AL_FLANGER_DEFAULT_FEEDBACK             

        AL_FLANGER_MIN_DELAY                    
        AL_FLANGER_MAX_DELAY                    
        AL_FLANGER_DEFAULT_DELAY                

        # Frequency shifter effect 
        AL_FREQUENCY_SHIFTER_MIN_FREQUENCY      
        AL_FREQUENCY_SHIFTER_MAX_FREQUENCY      
        AL_FREQUENCY_SHIFTER_DEFAULT_FREQUENCY  

        AL_FREQUENCY_SHIFTER_MIN_LEFT_DIRECTION 
        AL_FREQUENCY_SHIFTER_MAX_LEFT_DIRECTION 
        AL_FREQUENCY_SHIFTER_DEFAULT_LEFT_DIRECTION

        AL_FREQUENCY_SHIFTER_DIRECTION_DOWN     
        AL_FREQUENCY_SHIFTER_DIRECTION_UP       
        AL_FREQUENCY_SHIFTER_DIRECTION_OFF      

        AL_FREQUENCY_SHIFTER_MIN_RIGHT_DIRECTION
        AL_FREQUENCY_SHIFTER_MAX_RIGHT_DIRECTION
        AL_FREQUENCY_SHIFTER_DEFAULT_RIGHT_DIRECTION

        # Vocal morpher effect 
        AL_VOCAL_MORPHER_MIN_PHONEMEA           
        AL_VOCAL_MORPHER_MAX_PHONEMEA           
        AL_VOCAL_MORPHER_DEFAULT_PHONEMEA       

        AL_VOCAL_MORPHER_MIN_PHONEMEA_COARSE_TUNING
        AL_VOCAL_MORPHER_MAX_PHONEMEA_COARSE_TUNING
        AL_VOCAL_MORPHER_DEFAULT_PHONEMEA_COARSE_TUNING

        AL_VOCAL_MORPHER_MIN_PHONEMEB           
        AL_VOCAL_MORPHER_MAX_PHONEMEB           
        AL_VOCAL_MORPHER_DEFAULT_PHONEMEB       

        AL_VOCAL_MORPHER_MIN_PHONEMEB_COARSE_TUNING
        AL_VOCAL_MORPHER_MAX_PHONEMEB_COARSE_TUNING
        AL_VOCAL_MORPHER_DEFAULT_PHONEMEB_COARSE_TUNING

        AL_VOCAL_MORPHER_PHONEME_A              
        AL_VOCAL_MORPHER_PHONEME_E              
        AL_VOCAL_MORPHER_PHONEME_I              
        AL_VOCAL_MORPHER_PHONEME_O              
        AL_VOCAL_MORPHER_PHONEME_U              
        AL_VOCAL_MORPHER_PHONEME_AA             
        AL_VOCAL_MORPHER_PHONEME_AE             
        AL_VOCAL_MORPHER_PHONEME_AH             
        AL_VOCAL_MORPHER_PHONEME_AO             
        AL_VOCAL_MORPHER_PHONEME_EH             
        AL_VOCAL_MORPHER_PHONEME_ER             
        AL_VOCAL_MORPHER_PHONEME_IH             
        AL_VOCAL_MORPHER_PHONEME_IY             
        AL_VOCAL_MORPHER_PHONEME_UH             
        AL_VOCAL_MORPHER_PHONEME_UW             
        AL_VOCAL_MORPHER_PHONEME_B              
        AL_VOCAL_MORPHER_PHONEME_D              
        AL_VOCAL_MORPHER_PHONEME_F              
        AL_VOCAL_MORPHER_PHONEME_G              
        AL_VOCAL_MORPHER_PHONEME_J              
        AL_VOCAL_MORPHER_PHONEME_K              
        AL_VOCAL_MORPHER_PHONEME_L              
        AL_VOCAL_MORPHER_PHONEME_M              
        AL_VOCAL_MORPHER_PHONEME_N              
        AL_VOCAL_MORPHER_PHONEME_P              
        AL_VOCAL_MORPHER_PHONEME_R              
        AL_VOCAL_MORPHER_PHONEME_S              
        AL_VOCAL_MORPHER_PHONEME_T              
        AL_VOCAL_MORPHER_PHONEME_V              
        AL_VOCAL_MORPHER_PHONEME_Z              

        AL_VOCAL_MORPHER_WAVEFORM_SINUSOID      
        AL_VOCAL_MORPHER_WAVEFORM_TRIANGLE      
        AL_VOCAL_MORPHER_WAVEFORM_SAWTOOTH      

        AL_VOCAL_MORPHER_MIN_WAVEFORM           
        AL_VOCAL_MORPHER_MAX_WAVEFORM           
        AL_VOCAL_MORPHER_DEFAULT_WAVEFORM       

        AL_VOCAL_MORPHER_MIN_RATE               
        AL_VOCAL_MORPHER_MAX_RATE               
        AL_VOCAL_MORPHER_DEFAULT_RATE           

        # Pitch shifter effect 
        AL_PITCH_SHIFTER_MIN_COARSE_TUNE        
        AL_PITCH_SHIFTER_MAX_COARSE_TUNE        
        AL_PITCH_SHIFTER_DEFAULT_COARSE_TUNE    

        AL_PITCH_SHIFTER_MIN_FINE_TUNE          
        AL_PITCH_SHIFTER_MAX_FINE_TUNE          
        AL_PITCH_SHIFTER_DEFAULT_FINE_TUNE      

        # Ring modulator effect 
        AL_RING_MODULATOR_MIN_FREQUENCY         
        AL_RING_MODULATOR_MAX_FREQUENCY         
        AL_RING_MODULATOR_DEFAULT_FREQUENCY     

        AL_RING_MODULATOR_MIN_HIGHPASS_CUTOFF   
        AL_RING_MODULATOR_MAX_HIGHPASS_CUTOFF   
        AL_RING_MODULATOR_DEFAULT_HIGHPASS_CUTOFF

        AL_RING_MODULATOR_SINUSOID              
        AL_RING_MODULATOR_SAWTOOTH              
        AL_RING_MODULATOR_SQUARE                

        AL_RING_MODULATOR_MIN_WAVEFORM          
        AL_RING_MODULATOR_MAX_WAVEFORM          
        AL_RING_MODULATOR_DEFAULT_WAVEFORM      

        # Autowah effect 
        AL_AUTOWAH_MIN_ATTACK_TIME              
        AL_AUTOWAH_MAX_ATTACK_TIME              
        AL_AUTOWAH_DEFAULT_ATTACK_TIME          

        AL_AUTOWAH_MIN_RELEASE_TIME             
        AL_AUTOWAH_MAX_RELEASE_TIME             
        AL_AUTOWAH_DEFAULT_RELEASE_TIME         

        AL_AUTOWAH_MIN_RESONANCE                
        AL_AUTOWAH_MAX_RESONANCE                
        AL_AUTOWAH_DEFAULT_RESONANCE            

        AL_AUTOWAH_MIN_PEAK_GAIN                
        AL_AUTOWAH_MAX_PEAK_GAIN                
        AL_AUTOWAH_DEFAULT_PEAK_GAIN            

        # Compressor effect 
        AL_COMPRESSOR_MIN_ONOFF                 
        AL_COMPRESSOR_MAX_ONOFF                 
        AL_COMPRESSOR_DEFAULT_ONOFF             

        # Equalizer effect 
        AL_EQUALIZER_MIN_LOW_GAIN               
        AL_EQUALIZER_MAX_LOW_GAIN               
        AL_EQUALIZER_DEFAULT_LOW_GAIN           

        AL_EQUALIZER_MIN_LOW_CUTOFF             
        AL_EQUALIZER_MAX_LOW_CUTOFF             
        AL_EQUALIZER_DEFAULT_LOW_CUTOFF         

        AL_EQUALIZER_MIN_MID1_GAIN              
        AL_EQUALIZER_MAX_MID1_GAIN              
        AL_EQUALIZER_DEFAULT_MID1_GAIN          

        AL_EQUALIZER_MIN_MID1_CENTER            
        AL_EQUALIZER_MAX_MID1_CENTER            
        AL_EQUALIZER_DEFAULT_MID1_CENTER        

        AL_EQUALIZER_MIN_MID1_WIDTH             
        AL_EQUALIZER_MAX_MID1_WIDTH             
        AL_EQUALIZER_DEFAULT_MID1_WIDTH         

        AL_EQUALIZER_MIN_MID2_GAIN              
        AL_EQUALIZER_MAX_MID2_GAIN              
        AL_EQUALIZER_DEFAULT_MID2_GAIN          

        AL_EQUALIZER_MIN_MID2_CENTER            
        AL_EQUALIZER_MAX_MID2_CENTER            
        AL_EQUALIZER_DEFAULT_MID2_CENTER        

        AL_EQUALIZER_MIN_MID2_WIDTH             
        AL_EQUALIZER_MAX_MID2_WIDTH             
        AL_EQUALIZER_DEFAULT_MID2_WIDTH         

        AL_EQUALIZER_MIN_HIGH_GAIN              
        AL_EQUALIZER_MAX_HIGH_GAIN              
        AL_EQUALIZER_DEFAULT_HIGH_GAIN          

        AL_EQUALIZER_MIN_HIGH_CUTOFF            
        AL_EQUALIZER_MAX_HIGH_CUTOFF            
        AL_EQUALIZER_DEFAULT_HIGH_CUTOFF        


        # Source parameter value ranges and defaults. 
        AL_MIN_AIR_ABSORPTION_FACTOR            
        AL_MAX_AIR_ABSORPTION_FACTOR            
        AL_DEFAULT_AIR_ABSORPTION_FACTOR        

        AL_MIN_ROOM_ROLLOFF_FACTOR              
        AL_MAX_ROOM_ROLLOFF_FACTOR              
        AL_DEFAULT_ROOM_ROLLOFF_FACTOR          

        AL_MIN_CONE_OUTER_GAINHF                
        AL_MAX_CONE_OUTER_GAINHF                
        AL_DEFAULT_CONE_OUTER_GAINHF            

        AL_MIN_DIRECT_FILTER_GAINHF_AUTO        
        AL_MAX_DIRECT_FILTER_GAINHF_AUTO        
        AL_DEFAULT_DIRECT_FILTER_GAINHF_AUTO    

        AL_MIN_AUXILIARY_SEND_FILTER_GAIN_AUTO  
        AL_MAX_AUXILIARY_SEND_FILTER_GAIN_AUTO  
        AL_DEFAULT_AUXILIARY_SEND_FILTER_GAIN_AUTO

        AL_MIN_AUXILIARY_SEND_FILTER_GAINHF_AUTO
        AL_MAX_AUXILIARY_SEND_FILTER_GAINHF_AUTO
        AL_DEFAULT_AUXILIARY_SEND_FILTER_GAINHF_AUTO


        # Listener parameter value ranges and defaults. 
        AL_MIN_METERS_PER_UNIT                  
        AL_MAX_METERS_PER_UNIT                  
        AL_DEFAULT_METERS_PER_UNIT              

    void alGenEffects(al.ALsizei n, al.ALuint *effects)
    void alDeleteEffects(al.ALsizei n, const al.ALuint *effects)
    al.ALboolean alIsEffect(al.ALuint effect)
    void alEffecti(al.ALuint effect, al.ALenum param, al.ALint iValue)
    void alEffectiv(al.ALuint effect, al.ALenum param, const al.ALint *piValues)
    void alEffectf(al.ALuint effect, al.ALenum param, al.ALfloat flValue)
    void alEffectfv(al.ALuint effect, al.ALenum param, const al.ALfloat *pflValues)
    void alGetEffecti(al.ALuint effect, al.ALenum param, al.ALint *piValue)
    void alGetEffectiv(al.ALuint effect, al.ALenum param, al.ALint *piValues)
    void alGetEffectf(al.ALuint effect, al.ALenum param, al.ALfloat *pflValue)
    void alGetEffectfv(al.ALuint effect, al.ALenum param, al.ALfloat *pflValues)

    void alGenFilters(al.ALsizei n, al.ALuint *filters)
    void alDeleteFilters(al.ALsizei n, const al.ALuint *filters)
    al.ALboolean alIsFilter(al.ALuint filter)
    void alFilteri(al.ALuint filter, al.ALenum param, al.ALint iValue)
    void alFilteriv(al.ALuint filter, al.ALenum param, const al.ALint *piValues)
    void alFilterf(al.ALuint filter, al.ALenum param, al.ALfloat flValue)
    void alFilterfv(al.ALuint filter, al.ALenum param, const al.ALfloat *pflValues)
    void alGetFilteri(al.ALuint filter, al.ALenum param, al.ALint *piValue)
    void alGetFilteriv(al.ALuint filter, al.ALenum param, al.ALint *piValues)
    void alGetFilterf(al.ALuint filter, al.ALenum param, al.ALfloat *pflValue)
    void alGetFilterfv(al.ALuint filter, al.ALenum param, al.ALfloat *pflValues)

    void alGenAuxiliaryEffectSlots(al.ALsizei n, al.ALuint *effectslots)
    void alDeleteAuxiliaryEffectSlots(al.ALsizei n, const al.ALuint *effectslots)
    al.ALboolean alIsAuxiliaryEffectSlot(al.ALuint effectslot)
    void alAuxiliaryEffectSloti(al.ALuint effectslot, al.ALenum param, al.ALint iValue)
    void alAuxiliaryEffectSlotiv(al.ALuint effectslot, al.ALenum param, const al.ALint *piValues)
    void alAuxiliaryEffectSlotf(al.ALuint effectslot, al.ALenum param, al.ALfloat flValue)
    void alAuxiliaryEffectSlotfv(al.ALuint effectslot, al.ALenum param, const al.ALfloat *pflValues)
    void alGetAuxiliaryEffectSloti(al.ALuint effectslot, al.ALenum param, al.ALint *piValue)
    void alGetAuxiliaryEffectSlotiv(al.ALuint effectslot, al.ALenum param, al.ALint *piValues)
    void alGetAuxiliaryEffectSlotf(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValue)
    void alGetAuxiliaryEffectSlotfv(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValues)
