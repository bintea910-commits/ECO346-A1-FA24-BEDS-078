# Q5: reproduce Q3 weighted literacy in Python
from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
Path('figures').mkdir(exist_ok=True)
hh=pd.read_csv('data/pslm_hh_subset.csv')
pp=pd.read_csv('data/pslm_person_subset.csv')
pp=pp.drop(columns=['hhweight','prov_code','urban_rural'],errors='ignore')
d=pp.merge(hh[['hhid','hhweight','prov_code','urban_rural']],on='hhid',how='left',validate='many_to_one')
d=d.loc[(d.prov_code==4)&(d.urban_rural==1)&d.age.between(10,64)&d.literate.notna()&d.sex.isin([1,2])&np.isfinite(d.hhweight)&(d.hhweight>0)].copy()
d['mid']=(10+5*((d.age-10)//5)+2).astype(int)
d['gender']=d.sex.map({1:'Men',2:'Women'})
rows=[]
for (mid,gender),g in d.groupby(['mid','gender']):
    rows.append(dict(mid=int(mid),band=f'{int(mid)-2}-{int(mid)+2}',gender=gender,n=len(g),rate=100*np.average(g.literate,weights=g.hhweight)))
tab=pd.DataFrame(rows).sort_values(['mid','gender'])
tab.to_csv('figures/q5_band_table_python.csv',index=False)
print(tab.to_string(index=False,float_format=lambda x:f'{x:.2f}'))
for gender,color in [('Men','#2863B0'),('Women','#C94F6D')]:
    s=tab[tab.gender==gender]
    plt.plot(s.mid,s.rate,color=color,lw=2)
    thick=s[s.n>=30]; thin=s[s.n<30]
    plt.scatter(thick.mid,thick.rate,color=color,s=30)
    plt.scatter(thin.mid,thin.rate,facecolors='white',edgecolors=color,s=45)
    if len(s): plt.text(s.mid.iloc[-1]+1,s.rate.iloc[-1],gender,color=color)
wide=tab.pivot(index='mid',columns='gender',values='rate')
if {'Men','Women'}.issubset(wide.columns):
    gaps=wide.Men-wide.Women
    m=int(gaps.idxmax()); gap=float(gaps.loc[m]);
    plt.annotate(f'Largest gap: {m-2}-{m+2} ({gap:.1f} pp)',(m,(wide.loc[m,'Men']+wide.loc[m,'Women'])/2),xytext=(m+3,80),arrowprops={'arrowstyle':'->'})
plt.xlim(10,70); plt.ylim(0,100); plt.xticks(range(12,63,5)); plt.yticks(range(0,101,20))
plt.xlabel('Age-band midpoint (years)'); plt.ylabel('Weighted literacy rate (%)')
plt.title('Literacy differs by age and gender in rural Balochistan')
plt.figtext(.5,.005,'PSLM 2019–20; ages 10–64; hhweight. Hollow markers: n < 30.',ha='center',fontsize=8)
plt.tight_layout(rect=(0,.04,1,1)); plt.savefig('figures/q5_python.svg'); plt.close()
rfile=Path('figures/q3_band_table_R.csv')
if rfile.exists():
    r=pd.read_csv(rfile)
    chk=r.merge(tab,on=['mid','gender'],suffixes=('_R','_Python'))
    print('R/Python agree to 1 decimal:', bool((chk.rate_R.round(1)==chk.rate_Python.round(1)).all()))
