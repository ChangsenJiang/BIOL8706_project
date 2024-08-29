import pandas as pd
df1 = pd.read_excel('d:/BIOL8706_project/data/clade_abr.xlsx')  # 包含物种名和简写
df2 = pd.read_excel('d:/BIOL8706_project/data/filter_templete/abvr.xlsx')  # 只包含简写
df2['clade'] = df2['code'].map(df1.set_index('code')['clade'])
df2.to_excel('d:/BIOL8706_project/data/updated_clade.xlsx', index=False)

