from sqlalchemy import create_engine
from datetime import datetime
import numpy as np
import pandas as pd
import warnings
import re
import math
import logging



# row 생략 없이 출력
pd.set_option('display.max_rows', None)
# col 생략 없이 출력
pd.set_option('display.max_columns', None)
# warning 무시
# warnings.filterwarnings(action='ignore')

# 이상치판단 대상 선언
rcs_list = ['INTEL_A', 'INTEL_B','MLS1', 'MLS2A', 'MLS2B', 'MLS3']
tag_list = [
    ['tag_1', 'tag_2', 'tag_3', 'tag_4'],
    ['tag_1', 'tag_2', 'tag_3', 'tag_4', 'tag_5', 'tag_6', 'tag_7', 'tag_8', 'tag_9', 'tag_10',
     'tag_11', 'tag_12', 'tag_13', 'tag_14', 'tag_15', 'tag_16', 'tag_17', 'tag_18', 'tag_19', 'tag_20',
     'tag_21', 'tag_22', 'tag_23', 'tag_24', 'tag_25', 'tag_26', 'tag_27', 'tag_28',
     'tag_29', 'tag_30', 'tag_31', 'tag_32', 'tag_33', 'tag_34', 'tag_35','tag_36'],
    ['tag_7'],
    ['tag_1', 'tag_2', 'tag_3', 'tag_4', 'tag_5', 'tag_6', 'tag_7', 'tag_8', 'tag_9', 'tag_10',
     'tag_11', 'tag_12', 'tag_13', 'tag_14', 'tag_15', 'tag_16',
     'tag_25', 'tag_26', 'tag_27', 'tag_28', 'tag_29', 'tag_30',
     'tag_31', 'tag_32', 'tag_33', 'tag_34', 'tag_35', 'tag_36', 'tag_37', 'tag_38', 'tag_39', 'tag_40'],
    ['tag_1', 'tag_2', 'tag_3', 'tag_4', 'tag_5', 'tag_6', 'tag_7', 'tag_8', 'tag_9'],
    ['tag_4']
]

# 데이터 상한,하한 기준 선언
minmaxValue = [
               [ ['INFLOW_TSS_DNSTY', 24.0, 480.0], ['INFLOW_TOC_DNSTY', 7.0, 234.0], ['INFLOW_TN_DNSTY', 9.0, 96.0],
                ['INFLOW_TP_DNSTY', 0.9, 9.4]],
                [['FRST_SDMT_TANK_OVFL_NH4N_A1', 0.1, 22.2], ['FRST_SDMT_TANK_OVFL_NO3N_A1', 0.1, 4.0],
                ['FRST_SDMT_TANK_OVFL_NH4N_B2', 0.1, 22.2], ['FRST_SDMT_TANK_OVFL_NO3N_B2', 0.1, 4.0],
                ['AARB_TANK_NH4N_B1', 0.1, 22.2], ['AARB_TANK_NO3N_B1', 0.1, 4.0],
                ['AARB_TANK_NH4N_B2', 0.1, 22.2], ['AARB_TANK_NO3N_B2', 0.1, 4.0],
                ['AARB_TANK_NH4N_A3', 0.1, 22.2], ['AARB_TANK_NO3N_A3', 0.1, 4.0],
                ['AARB_TANK_NH4N_A4', 0.1, 22.2], ['AARB_TANK_NO3N_A4', 0.1, 4.0],
                ['ANX_TANK_NH4N_B1', 0.1, 11.6], ['ANX_TANK_NO3N_B1', 0.1, 3.3],
                ['ANX_TANK_NH4N_B2', 0.1, 11.6], ['ANX_TANK_NO3N_B2', 0.1, 3.3],
                ['ANX_TANK_NH4N_A3', 0.1, 11.6], ['ANX_TANK_NO3N_A3', 0.1, 3.3],
                ['ANX_TANK_NH4N_A4', 0.1, 11.6], ['ANX_TANK_NO3N_A4', 0.1, 3.3],
                ['ARB_TANK_NH4N_B1', 0.1, 1.5], ['ARB_TANK_NO3N_B1', 0.1, 10.4],
                ['ARB_TANK_NH4N_B2', 0.1, 1.5], ['ARB_TANK_NO3N_B2', 0.1, 10.4],
                ['ARB_TANK_NH4N_A3', 0.1, 1.5], ['ARB_TANK_NO3N_A3', 0.1, 10.4],
                ['ARB_TANK_NH4N_A4', 0.1, 1.5], ['ARB_TANK_NO3N_A4', 0.1, 10.4],
                ['SLG_IF_A1', 0, 9999], ['SLG_IF_A2', 0, 9999],
                ['SLG_IF_A3', 0, 9999], ['SLG_IF_A4', 0, 9999],
                ['SLG_IF_B1', 0, 9999], ['SLG_IF_B2', 0, 9999],
                ['SLG_IF_B3', 0, 9999], ['SLG_IF_B4', 0, 9999]],    
                [['TOT_INFLOW_FLUX', 0, 9999],],    
                [['WOT_VOL_A1', 0, 9999], ['WOT_VOL_A2', 0, 9999],
                ['WOT_VOL_A3', 0, 9999], ['WOT_VOL_A4', 0, 9999],
                ['WOT_VOL_B1', 0, 9999], ['WOT_VOL_B2', 0, 9999],
                ['WOT_VOL_B3', 0, 9999], ['WOT_VOL_B4', 0, 9999],
                ['RTN_SLG_FLOW_A1', 0, 9999], ['RTN_SLG_FLOW_A2', 0, 9999],
                ['RTN_SLG_FLOW_A3', 0, 9999], ['RTN_SLG_FLOW_A4', 0, 9999],
                ['RTN_SLG_FLOW_B1', 0, 9999], ['RTN_SLG_FLOW_B2', 0, 9999],
                ['RTN_SLG_FLOW_B3', 0, 9999], ['RTN_SLG_FLOW_B4', 0, 9999],
                ['DO_A1', 0.1, 7.7], ['DO_A2', 0.1, 7.7], ['DO_A3', 0.1, 7.7], ['DO_A4', 0.1, 7.7],
                ['DO_B1', 0.1, 7.7], ['DO_B2', 0.1, 7.7], ['DO_B3', 0.1, 7.7], ['DO_B4', 0.1, 7.7],
                ['MLSS_A1', 1092.0, 5500.0], ['MLSS_A2', 1092.0, 5500.0],
                ['MLSS_A3', 1092.0, 5500.0], ['MLSS_A4', 1092.0, 5500.0],
                ['MLSS_B1', 1092.0, 5500.0], ['MLSS_B2', 1092.0, 5500.0],
                ['MLSS_B3', 1092.0, 5500.0], ['MLSS_B4', 1092.0, 5500.0]],    
                [['EC_SLG_FLOW', 0, 9999],
                ['INTER_RTN_FLOW_A1', 0, 9999], ['INTER_RTN_FLOW_A2', 0, 9999],
                ['INTER_RTN_FLOW_A3', 0, 9999], ['INTER_RTN_FLOW_A4', 0, 9999],
                ['INTER_RTN_FLOW_B1', 0, 9999], ['INTER_RTN_FLOW_B2', 0, 9999],
                ['INTER_RTN_FLOW_B3', 0, 9999], ['INTER_RTN_FLOW_B4', 0, 9999]],
                [['SIDSWT', 0, 9999],]
        ]

select_tag = {
    'INTEL_B1' : ['tag_2','tag_4','tag_6','tag_8','tag_10','tag_12','tag_14','tag_16','tag_18','tag_20','tag_21','tag_23','tag_25','tag_27',\
         'tag_29', 'tag_30', 'tag_31', 'tag_32', 'tag_33', 'tag_34', 'tag_35','tag_36'],
    'MLS2B1' : ['tag_1'],
    'INTEL_A1' : ['tag_4'],
    'INTEL_B2' : ['tag_22', 'tag_24', 'tag_26', 'tag_28'],
    'MLS2A1' : ['tag_25', 'tag_26', 'tag_27', 'tag_28', 'tag_29', 'tag_30', 'tag_31', 'tag_32'],
    'INTEL_A2' : ['tag_2', 'tag_3'],
    'INTEL_B3' : ['tag_1', 'tag_3', 'tag_5','tag_7','tag_9','tag_11','tag_13','tag_15','tag_17','tag_19'],
    'INTEL_A3' : ['tag_1'],
    'MLS2A2' : ['tag_1', 'tag_2', 'tag_3', 'tag_4', 'tag_5', 'tag_6', 'tag_7', 'tag_8',\
               'tag_9', 'tag_10', 'tag_11', 'tag_12', 'tag_13', 'tag_14', 'tag_15', 'tag_16',],
    'MLS12' : ['tag_7'],
    'MLS2A3' : ['tag_33', 'tag_34', 'tag_35', 'tag_36', 'tag_37', 'tag_38', 'tag_39', 'tag_40'],
    'MLS2B2' : [ 'tag_2', 'tag_3', 'tag_4', 'tag_5', 'tag_6', 'tag_7', 'tag_8', 'tag_9'],
    'MLS31' : ['tag_4']
}


#-----------------------------------------------------------------------------------------------------------------------

# 데이터 Insert
def insert_process(tabel_name,df_final):
    engine = create_engine('postgresql://')
    try:
        # 데이터프레임을 DB 테이블에 삽입
        df_final.to_sql(tabel_name, engine, if_exists='append', index=False)
    finally:
        # 연결 종료
        engine.dispose()

#log남기기
logger = logging.getLogger(name='')  # RootLogger
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter('|%(asctime)s||%(name)s||%(levelname)s|\n%(message)s', datefmt='%Y-%m-%d %H:%M:%S')
file_handler = logging.FileHandler('test.log') ## 파일 핸들러 생성
file_handler.setFormatter(formatter) ## 텍스트 포맷 설정
logger.addHandler(file_handler) ## 핸들러 등록

#-----------------------------------------------------------------------------------------------------------------------

# ms001m데이터 가져오기
engine = create_engine('postgresql://')

try:
    sql_query = """
    SELECT *
    FROM asswms001m
    WHERE meas_dtm IN (
        SELECT DISTINCT meas_dtm
        FROM asswms001m
        ORDER BY meas_dtm DESC
        LIMIT 6
    )
    ORDER BY meas_dtm;
    """
    logging.info('Start fetching data from database')
    df = pd.read_sql_query(sql_query, engine)
    
    # 컬럼 이름 지정
    tags = ['tag_' + str(i) for i in range(1, len(df.columns) - 2)]
    df.columns = ['meas_dtm', 'rcs_id', 'data_typ'] + tags
    df[tags] = df[tags].astype(float)
    df.reset_index(inplace=True, drop=True)
except Exception as e:
    logging.error('Error while fetching data from database: %s', e)
finally:
    # 연결 종료
    engine.dispose()

try:
    logging.info('Start processing data')
    # 2. 원본 전체 데이터 df 복사
    dfX = df.copy()


    # 상한하한 적용
    for i in range(len(rcs_list)):
        for j in range(len(tag_list[i])):
            dfX.loc[(dfX['rcs_id'] == rcs_list[i]) & (dfX['data_typ'] == 'AI'), tag_list[i][j]] = \
                dfX.loc[(dfX['rcs_id'] == rcs_list[i]) & (dfX['data_typ'] == 'AI'), tag_list[i][j]].clip(lower=minmaxValue[i][j][1], upper=minmaxValue[i][j][2])

    dfR = dfX.copy()
    df003 = dfX.copy()
    df004 = dfX.copy() 
    
    # 1. 0.__ → +-10
    for key, value in list(select_tag.items())[:2]:
        rcs_id_filter = (dfR['rcs_id'] == key[:-1]) & (dfR['data_typ'] == 'AI')
        tmp = dfR.loc[rcs_id_filter, value]
        columns = tmp.columns

        for i in range(len(columns)):
            column = columns[i]
            x = tmp.iloc[-1, i]
            data = tmp.iloc[1:, i]
            median = data.apply(lambda x: float('%.1f' % x)).median()
            mad = round(((data - median).abs()).median(), 2)
            mean = tmp.iloc[:5, i].mean()

            df003_filter = df003.loc[rcs_id_filter].index[-1]
            df004_filter = df004.loc[rcs_id_filter].index[-1]

            if(mad == 0):
                if((tmp.iloc[1:5,i].mean() * 4) < x):
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean
            else:
                zscore = 0.6745 * (x - median) / mad
                if abs(zscore) > 10:
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean

    # 2. ._ → +-200
    for key, value in list(select_tag.items())[2:5]:
        rcs_id_filter = (dfR['rcs_id'] == key[:-1]) & (dfR['data_typ'] == 'AI')
        tmp = dfR.loc[rcs_id_filter, value]
        columns = tmp.columns

        for i in range(len(columns)):
            column = columns[i]
            x = tmp.iloc[-1, i]
            data = tmp.iloc[1:, i]
            median = data.apply(lambda x: float('%.2f' % x)).median()
            mad = round(((data - median).abs()).median(), 2)
            mean = tmp.iloc[:5, i].mean()

            df003_filter = df003.loc[rcs_id_filter].index[-1]
            df004_filter = df004.loc[rcs_id_filter].index[-1]

            if(mad == 0):
                if((tmp.iloc[1:5,i].mean() * 4) < x):
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean
            else:
                zscore = 0.6745 * (x - median) / mad
                if abs(zscore) > 200:
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean

    # 3. 십의 자리 → +-25
    for key, value in list(select_tag.items())[5:7]:
        rcs_id_filter = (dfR['rcs_id'] == key[:-1]) & (dfR['data_typ'] == 'AI')
        tmp = dfR.loc[rcs_id_filter, value]
        columns = tmp.columns

        for i in range(len(columns)):
            column = columns[i]
            x = tmp.iloc[-1, i]
            data = tmp.iloc[1:, i]
            median = data.apply(lambda x: float('%.1f' % x)).median()
            mad = round(((data - median).abs()).median(), 2)
            mean = tmp.iloc[:5, i].mean()

            df003_filter = df003.loc[rcs_id_filter].index[-1]
            df004_filter = df004.loc[rcs_id_filter].index[-1]

            if(mad == 0):
                if((tmp.iloc[1:5,i].mean() * 4) < x):
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean
            else:
                zscore = 0.6745 * (x - median) / mad
                if abs(zscore) > 25:
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean

    # 4. 백의 자리 → +-50
    for key, value in list(select_tag.items())[7:9]:
        rcs_id_filter = (dfR['rcs_id'] == key[:-1]) & (dfR['data_typ'] == 'AI')
        tmp = dfR.loc[rcs_id_filter, value]
        columns = tmp.columns

        for i in range(len(columns)):
            column = columns[i]
            x = tmp.iloc[-1, i]
            data = tmp.iloc[1:, i]
            median = data.apply(lambda x: float('%.1f' % x)).median()
            mad = round(((data - median).abs()).median(), 2)
            mean = tmp.iloc[:5, i].mean()

            df003_filter = df003.loc[rcs_id_filter].index[-1]
            df004_filter = df004.loc[rcs_id_filter].index[-1]

            if(mad == 0):
                if((tmp.iloc[1:5,i].mean() * 4) < x):
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean
            else:
                zscore = 0.6745 * (x - median) / mad
                if abs(zscore) > 50:
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean

    # 5. 천의 자리 → +-40
    for key, value in list(select_tag.items())[9:]:
        rcs_id_filter = (dfR['rcs_id'] == key[:-1]) & (dfR['data_typ'] == 'AI')
        tmp = dfR.loc[rcs_id_filter, value]
        columns = tmp.columns

        for i in range(len(columns)):
            column = columns[i]
            x = tmp.iloc[-1, i]
            data = tmp.iloc[1:, i]
            median = data.apply(lambda x: math.floor(x)).median()
            # print(median)
            mad = round(((data - median).abs()).median(), 2)
            mean = tmp.iloc[:5, i].mean()

            df003_filter = df003.loc[rcs_id_filter].index[-1]
            df004_filter = df004.loc[rcs_id_filter].index[-1]

            if(mad == 0):
                if((tmp.iloc[1:5,i].mean() * 4) < x):
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean
            else:
                zscore = 0.6745 * (x - median) / mad
                if abs(zscore) > 40:
                    df003.loc[df003_filter, column] = np.nan
                    df004.loc[df004_filter, column] = mean
except Exception as e:
    logging.error('Error while processing data: %s', e)



try:
    logging.info('Start saving data to database')
    # ~ms003m, ~ms004m테이블에 insert
    now = dfX['meas_dtm'].max()
    insert_process('asswms003m_test', df003.loc[df003['meas_dtm'] == now])
    insert_process('asswms004m_test', df004.loc[df004['meas_dtm'] == now])
except Exception as e:
    logging.error('Error while saving data to database: %s', e)

