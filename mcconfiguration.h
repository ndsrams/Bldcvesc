#ifndef DATAWRAPPERS_H
#define MCCONFIGURATION_H

#include <QObject>
#include <QList>
#include "datatypes.h"
#include "lib-qt-qml-tricks/src/qqmlhelpers.h"

class McConfiguration : public QObject
{
    Q_OBJECT
public:
    typedef enum {
        COMM_MODE_INTEGRATE = 0,
        COMM_MODE_DELAY
    } MC_comm_mode;

    typedef enum {
        SENSOR_MODE_SENSORLESS = 0,
        SENSOR_MODE_SENSORED,
        SENSOR_MODE_HYBRID
    } MC_sensor_mode;

    typedef enum {
        FOC_SENSOR_MODE_SENSORLESS = 0,
        FOC_SENSOR_MODE_ENCODER,
        FOC_SENSOR_MODE_HALL
    } MC_foc_sensor_mode;

    typedef enum {
        MOTOR_TYPE_BLDC = 0,
        MOTOR_TYPE_DC,
        MOTOR_TYPE_FOC
    } MC_motor_type;

    typedef enum {
        PWM_MODE_NONSYNCHRONOUS_HISW = 0, // This mode is not recommended
        PWM_MODE_SYNCHRONOUS, // The recommended and most tested mode
        PWM_MODE_BIPOLAR // Some glitches occasionally, can kill MOSFETs
    } MC_pwm_mode;

    Q_ENUM(MC_comm_mode)
    Q_ENUM(MC_sensor_mode)
    Q_ENUM(MC_motor_type)
    Q_ENUM(MC_foc_sensor_mode)
    Q_ENUM(MC_pwm_mode)

    // Switching and drive
    QML_WRITABLE_ENUM_PROPERTY_W( MC_pwm_mode       ,pwm_mode   ,mc_pwm_mode    ,m_data.pwm_mode       )
    QML_WRITABLE_ENUM_PROPERTY_W( MC_comm_mode  	,comm_mode  ,mc_comm_mode   ,m_data.comm_mode   )
    QML_WRITABLE_ENUM_PROPERTY_W( MC_motor_type 	,motor_type ,mc_motor_type  ,m_data.motor_type  )
    QML_WRITABLE_ENUM_PROPERTY_W( MC_sensor_mode	,sensor_mode,mc_sensor_mode ,m_data.sensor_mode )
    // Limits
    QML_WRITABLE_PROPERTY_W( float	,l_current_max          ,m_data.l_current_max        )
    QML_WRITABLE_PROPERTY_W( float	,l_current_min          ,m_data.l_current_min        )
    QML_WRITABLE_PROPERTY_W( float	,l_in_current_max       ,m_data.l_in_current_max     )
    QML_WRITABLE_PROPERTY_W( float	,l_in_current_min       ,m_data.l_in_current_min     )
    QML_WRITABLE_PROPERTY_W( float	,l_abs_current_max      ,m_data.l_abs_current_max    )
    QML_WRITABLE_PROPERTY_W( float	,l_min_erpm             ,m_data.l_min_erpm           )
    QML_WRITABLE_PROPERTY_W( float	,l_max_erpm             ,m_data.l_max_erpm           )
    QML_WRITABLE_PROPERTY_W( float	,l_max_erpm_fbrake      ,m_data.l_max_erpm_fbrake    )
    QML_WRITABLE_PROPERTY_W( float	,l_max_erpm_fbrake_cc   ,m_data.l_max_erpm_fbrake_cc )
    QML_WRITABLE_PROPERTY_W( float	,l_min_vin              ,m_data.l_min_vin            )
    QML_WRITABLE_PROPERTY_W( float	,l_max_vin              ,m_data.l_max_vin            )
    QML_WRITABLE_PROPERTY_W( float	,l_battery_cut_start    ,m_data.l_battery_cut_start  )
    QML_WRITABLE_PROPERTY_W( float	,l_battery_cut_end      ,m_data.l_battery_cut_end    )
    QML_WRITABLE_PROPERTY_W( bool 	,l_slow_abs_current     ,m_data.l_slow_abs_current   )
    QML_WRITABLE_PROPERTY_W( bool 	,l_rpm_lim_neg_torque   ,m_data.l_rpm_lim_neg_torque )
    QML_WRITABLE_PROPERTY_W( float	,l_temp_fet_start       ,m_data.l_temp_fet_start     )
    QML_WRITABLE_PROPERTY_W( float	,l_temp_fet_end         ,m_data.l_temp_fet_end       )
    QML_WRITABLE_PROPERTY_W( float	,l_temp_motor_start     ,m_data.l_temp_motor_start   )
    QML_WRITABLE_PROPERTY_W( float	,l_temp_motor_end       ,m_data.l_temp_motor_end     )
    QML_WRITABLE_PROPERTY_W( float	,l_min_duty             ,m_data.l_min_duty           )
    QML_WRITABLE_PROPERTY_W( float	,l_max_duty             ,m_data.l_max_duty           )
    // Sensorless
    QML_WRITABLE_PROPERTY_W( float	,sl_min_erpm                           ,m_data.sl_min_erpm                         )
    QML_WRITABLE_PROPERTY_W( float	,sl_min_erpm_cycle_int_limit           ,m_data.sl_min_erpm_cycle_int_limit         )
    QML_WRITABLE_PROPERTY_W( float	,sl_max_fullbreak_current_dir_change   ,m_data.sl_max_fullbreak_current_dir_change )
    QML_WRITABLE_PROPERTY_W( float	,sl_cycle_int_limit                    ,m_data.sl_cycle_int_limit                  )
    QML_WRITABLE_PROPERTY_W( float	,sl_phase_advance_at_br                ,m_data.sl_phase_advance_at_br              )
    QML_WRITABLE_PROPERTY_W( float	,sl_cycle_int_rpm_br                   ,m_data.sl_cycle_int_rpm_br                 )
    QML_WRITABLE_PROPERTY_W( float	,sl_bemf_coupling_k                    ,m_data.sl_bemf_coupling_k                  )
    // Hall sensor
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table1     , m_data.hall_table[0], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table2     , m_data.hall_table[1], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table3     , m_data.hall_table[2], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table4     , m_data.hall_table[3], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table5     , m_data.hall_table[4], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table6     , m_data.hall_table[5], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table7     , m_data.hall_table[6], int8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,hall_table8     , m_data.hall_table[7], int8_t)
    QML_WRITABLE_PROPERTY_W( float 		,hall_sl_erpm   ,m_data.hall_sl_erpm)
    // FOC
    QML_WRITABLE_PROPERTY_W( float 				,foc_current_kp 		,m_data.foc_current_kp 		 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_current_ki 		,m_data.foc_current_ki 		 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_f_sw       		,m_data.foc_f_sw       		 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_dt_us				,m_data.foc_dt_us				 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_encoder_offset		,m_data.foc_encoder_offset		 )
    QML_WRITABLE_PROPERTY_W( bool 				,foc_encoder_inverted	,m_data.foc_encoder_inverted	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_encoder_ratio		,m_data.foc_encoder_ratio		 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_motor_l			,m_data.foc_motor_l			 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_motor_r			,m_data.foc_motor_r			 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_motor_flux_linkage	,m_data.foc_motor_flux_linkage	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_observer_gain		,m_data.foc_observer_gain		 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_pll_kp				,m_data.foc_pll_kp				 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_pll_ki				,m_data.foc_pll_ki				 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_duty_dowmramp_kp	,m_data.foc_duty_dowmramp_kp	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_duty_dowmramp_ki	,m_data.foc_duty_dowmramp_ki	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_openloop_rpm		,m_data.foc_openloop_rpm		 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_sl_openloop_hyst	,m_data.foc_sl_openloop_hyst	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_sl_openloop_time	,m_data.foc_sl_openloop_time	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_sl_d_current_duty	,m_data.foc_sl_d_current_duty	 )
    QML_WRITABLE_PROPERTY_W( float 				,foc_sl_d_current_factor,m_data.foc_sl_d_current_factor )
    QML_WRITABLE_ENUM_PROPERTY_W( MC_foc_sensor_mode ,foc_sensor_mode		,mc_foc_sensor_mode ,m_data.foc_sensor_mode)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table1     , m_data.foc_hall_table[0],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table2     , m_data.foc_hall_table[1],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table3     , m_data.foc_hall_table[2],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table4     , m_data.foc_hall_table[3],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table5     , m_data.foc_hall_table[4],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table6     , m_data.foc_hall_table[5],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table7     , m_data.foc_hall_table[6],uint8_t)
    QML_WRITABLE_PROPERTY_WRAPPER(int         ,foc_hall_table8     , m_data.foc_hall_table[7],uint8_t)
    QML_WRITABLE_PROPERTY_W( float 				,foc_hall_sl_erpm		,m_data.foc_sl_erpm )
    // Speed PID
    QML_WRITABLE_PROPERTY_W( float	,s_pid_kp		,m_data.s_pid_kp		 )
    QML_WRITABLE_PROPERTY_W( float	,s_pid_ki		,m_data.s_pid_ki		 )
    QML_WRITABLE_PROPERTY_W( float	,s_pid_kd		,m_data.s_pid_kd		 )
    QML_WRITABLE_PROPERTY_W( float	,s_pid_min_erpm	,m_data.s_pid_min_erpm	 )
    // Pos PID
    QML_WRITABLE_PROPERTY_W( float	,p_pid_kp       ,m_data.p_pid_kp )
    QML_WRITABLE_PROPERTY_W( float	,p_pid_ki       ,m_data.p_pid_ki )
    QML_WRITABLE_PROPERTY_W( float	,p_pid_kd       ,m_data.p_pid_kd )
    QML_WRITABLE_PROPERTY_W( float  ,p_pid_ang_div  ,m_data.p_pid_ang_div)
    // Current controller
    QML_WRITABLE_PROPERTY_W( float	,cc_startup_boost_duty		,m_data.cc_startup_boost_duty	 )
    QML_WRITABLE_PROPERTY_W( float	,cc_min_current				,m_data.cc_min_current			 )
    QML_WRITABLE_PROPERTY_W( float	,cc_gain					,m_data.cc_gain				 )
    QML_WRITABLE_PROPERTY_W( float	,cc_ramp_step_max			,m_data.cc_ramp_step_max		 )
    // Misc
    QML_WRITABLE_PROPERTY_WRAPPER( int	,m_fault_stop_time_ms       ,m_data.m_fault_stop_time_ms, int32_t)
    QML_WRITABLE_PROPERTY_W( float 		,m_duty_ramp_step			,m_data.m_duty_ramp_step		 )
    QML_WRITABLE_PROPERTY_W( float 		,m_duty_ramp_step_rpm_lim	,m_data.m_duty_ramp_step_rpm_lim )
    QML_WRITABLE_PROPERTY_W( float 		,m_current_backoff_gain		,m_data.m_current_backoff_gain	 )
    QML_WRITABLE_PROPERTY_WRAPPER( int	,m_encoder_counts           ,m_data.m_encoder_counts, uint32_t )
    // Fields that are only present in Qt
    QML_WRITABLE_PROPERTY_W( QString	,meta_description   ,m_data.meta_description )

public:
    explicit McConfiguration(QObject *parent = 0);
    McConfiguration(const mc_configuration &src);

    void setData(const mc_configuration &src);

    QList<int> foc_hall_table() const;
    QList<int> hall_table() const;

public slots:
    const mc_configuration& data();

private:
    mc_configuration m_data;
};

#endif // MCCONFIGURATION_H
