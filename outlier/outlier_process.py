from sqlalchemy import create_engine
from datetime import datetime
import numpy as np
import pandas as pd
import warnings

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

# -----------------------------------------------------------------------------------------------------------------------

# 함수 선언 영역
# 전체 데이터에서 이상치 판단 데이터 추출
def extract_and_process(df, rcs_id, tag_list):
    # DataFrame 타입 변수로 추출
    df_rcs = df.loc[(df['rcs_id'] == rcs_id) & (df['data_typ'] == 'AI')].reset_index(drop=True)
    # selected_columns = ['meas_dtm'] + tag_list
    # 필요한 컬럼만 추출
    df_rcs = df_rcs.loc[:, df_rcs.columns.isin(['meas_dtm'] + tag_list)]

    # 숫자 데이터 float 타입으로 수정
    df_rcs.set_index('meas_dtm', inplace=True)
    df_rcs = df_rcs.astype(float)
    df_rcs = df_rcs.reset_index(drop=False)
    return df_rcs


# 각 데이터의 차(diff) 추출
def add_diff(df, prefix, tag_columns):
    for i, tag_col in enumerate(tag_columns):
        df[f'{prefix}{i + 1}'] = df[tag_col].diff()


# 각 데이터와 중앙값의 차 추출
def add_median_diff(df, df_lists, prefix, tag_columns):
    for i, tag_col in enumerate(tag_columns):
        df[f'{prefix}_{i + 1}'] = (df_lists[tag_col] - df_lists.loc[:2][tag_col].median()).abs()


# 이상값 처리
def imputation(df_means, df_lists, df_diff, df_median_diff, tag_list, df_003):
    for i in range(len(tag_list)):
        mean = df_means.iloc[:, i + 1].mean()
        if(df_median_diff.iloc[:3, i+1].median() ==0):
            z_score = 0
        else:
            z_score = 0.6745 * df_median_diff.iloc[2, i+1] / df_median_diff.iloc[:3, i+1].median()
        if z_score < -3 or z_score > 3:
            if np.sign(df_diff.iloc[2, i + 1]) * np.sign(df_diff.iloc[3, i + 1]) < 0:
                df_003.iloc[2, i + 1] = np.nan
                df_lists.iloc[2, i + 1] = mean


# 데이터 상한,하한값 설정
def accept_minmax_value(df_list, minmaxValue, tag_lists):
    df_X = df_list.iloc[:, 1:]
    for i, tag in enumerate(tag_lists):
        df_list[tag] = df_list[tag].clip(lower=minmaxValue[i][1], upper=minmaxValue[i][2])


# 이상치 처리 후 데이터 원복
def return_Data(df_final, rcs_id, tag_list, df_lists):
    drs = df_final.loc[(df_final['rcs_id'] == rcs_id) & (df_final['data_typ'] == 'AI')]
    df_final = df_final.drop(drs.index)
    drs.loc[drs.index[-4]:, tag_list] = df_lists.iloc[:, 1:].values
    df_final = pd.concat([df_final, drs], ignore_index=True)
    return df_final


# 데이터 Insert
def insert_process(tabel_name, df_final):
    engine = create_engine('postgresql://')
    try:
        # 데이터프레임을 DB 테이블에 삽입
        df_final.to_sql(tabel_name, engine, if_exists='append', index=False)
    finally:
        # 연결 종료
        engine.dispose()


# -----------------------------------------------------------------------------------------------------------------------

# 작업 실행 영역
# 1. 전체 데이터 조회
# PostgreSQL 데이터베이스 연결
engine = create_engine('postgresql://')

try:
    sql_query = """
    SELECT *
    FROM asswms001m
    WHERE meas_dtm IN (
        SELECT DISTINCT meas_dtm
        FROM asswms001m
        ORDER BY meas_dtm DESC
        LIMIT 7
    )
    ORDER BY meas_dtm;
    """
    df = pd.read_sql_query(sql_query, engine)

    # 컬럼 이름 지정
    tags = ['tag_' + str(i) for i in range(1, len(df.columns) - 2)]
    df.columns = ['meas_dtm', 'rcs_id', 'data_typ'] + tags

    df.reset_index(inplace=True, drop=True)
finally:
    # 연결 종료
    engine.dispose()

# 2. 원본 전체 데이터 df 복사
dfX = df.copy()
df_final003 = dfX.copy()
df_final004 = dfX.copy()

# 3. 조건에 맞는 각 데이터 타입 변환 및 추출 (순서 : ['INTEL_A', 'INTEL_B','MLS1', 'MLS2A', 'MLS2B'])
df_lists = []  # 기본 데이터
df_means = []  # 이상값 판단 데이터 이전 5개 데이터
df_diff = []  # 각 데이터의 차
df_median_diff = []  # 각 데이터의 중앙값과의 차
df_003 = []
for i in range(len(rcs_list)):
    df_rcs = extract_and_process(dfX, rcs_list[i], tag_list[i])
    df_lists.append(df_rcs.iloc[3:].reset_index(drop=True))
    df_003.append(df_rcs.iloc[3:].reset_index(drop=True))
    df_diff.append(df_rcs.iloc[3:].reset_index(drop=True))
    df_median_diff.append(df_rcs.iloc[3:].reset_index(drop=True))
    df_means.append(df_rcs.iloc[:-2].reset_index(drop=True))

# df_diff 데이터 생성
for i, tag in enumerate(tag_list):
    add_diff(df_diff[i], f'diff_', tag)
    df_diff[i] = df_diff[i].iloc[:, [0] + list(range(len(tag) + 1, len(df_diff[i].columns)))]

# df_median_diff 데이터 생성
for i, tag in enumerate(tag_list):
    add_median_diff(df_median_diff[i], df_lists[i], f'median_diff', tag)
    df_median_diff[i] = df_median_diff[i].iloc[:, [0] + list(range(len(tag) + 1, len(df_median_diff[i].columns)))]

# 4. 이상치 처리
for i in range(len(rcs_list)):
    imputation(df_means[i], df_lists[i], df_diff[i], df_median_diff[i], tag_list[i], df_003[i])

inputMin = df_lists[0].iloc[2, 0]
current_time = datetime.now().replace(second=0, microsecond=0)  # 현재시간

# 5. asswms003m에 현재 시간으로 시간 수정 후 데이터 Insert
for i in range(len(tag_list)):
    df_final003 = return_Data(df_final003, rcs_list[i], tag_list[i], df_003[i])
df_final003 = df_final003.loc[df_final003['meas_dtm'] == inputMin].reset_index(drop=True)
df_final003['meas_dtm'] = df_final003['meas_dtm'].replace(inputMin, current_time)  # 현재 시간으로 수정(실데이터 시간 +2min)
df_final003 = df_final003.round(2)
insert_process('asswms003m', df_final003)

# 6. 데이터 상한, 하한 설정 적용
for i in range(len(tag_list)):
    accept_minmax_value(df_lists[i], minmaxValue[i], tag_list[i])

# # 7. 이상치 처리 후 데이터 원복
for i in range(len(rcs_list)):
    df_final004 = return_Data(df_final004, rcs_list[i], tag_list[i], df_lists[i])

# # 8. 전체 데이터에서 Insert할 데이터 추출 및 변환

df_final004 = df_final004.loc[df_final004['meas_dtm'] == inputMin].reset_index(drop=True)
df_final004['meas_dtm'] = df_final004['meas_dtm'].replace(inputMin, current_time)  # 현재 시간으로 수정(실데이터 시간 +2min)
df_final004 = df_final004.round(2)
# df_final004.to_csv('D:/an_0126_1.csv')
# print("이상치판단완료")
# # 9. asswms004m에 데이터 Insert
insert_process('asswms004m', df_final004)
