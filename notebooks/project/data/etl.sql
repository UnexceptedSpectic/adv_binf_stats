drop table if exists combined;
create table combined as
with demographic_dietary as (select 
demographics.SEQN as id,
demographics.RIAGENDR as gender,
demographics.RIDRETH3 as race,
demographics.RIDAGEYR as age,
demographics.DMDMARTL as marital_status,
demographics.RIDEXPRG as pregnant,
d1.DR1TKCAL as total_kcal,
d1.DR1TPROT as total_protein,
d1.DR1TCARB as total_carb,
d1.DR1TSUGR as total_sugar,
d1.DR1TSODI as total_sodium,
d1.DR1TFIBE as total_fiber,
d1.DR1TTFAT as total_total_fat,
d1.DR1TSFAT as total_sat_fat,
d1.DR1TMFAT as total_monounsat_fat,
d1.DR1TPFAT as total_polyunsat_fat,
d1.DR1TCHOL as total_cholesterol,
d1.DR1TCAFF as total_caffeine,
d1.DR1TALCO as total_alcohol
from nutrient_totals_d1 d1
join demographics
on d1.SEQN = demographics.SEQN
UNION 
select 
demographics.SEQN as id,
demographics.RIAGENDR as gender,
demographics.RIDRETH3 as race,
demographics.RIDAGEYR as age,
demographics.DMDMARTL as marital_status,
demographics.RIDEXPRG as pregnant,
d2.DR2TKCAL as total_kcal,
d2.DR2TPROT as total_protein,
d2.DR2TCARB as total_carb,
d2.DR2TSUGR as total_sugar,
d2.DR2TSODI as total_sodium,
d2.DR2TFIBE as total_fiber,
d2.DR2TTFAT as total_total_fat,
d2.DR2TSFAT as total_sat_fat,
d2.DR2TMFAT as total_monounsat_fat,
d2.DR2TPFAT as total_polyunsat_fat,
d2.DR2TCHOL as total_cholesterol,
d2.DR2TCAFF as total_caffeine,
d2.DR2TALCO as total_alcohol
from demographics
join nutrient_totals_d2 d2
on demographics.SEQN = d2.SEQN),
demographic_dietary_health as (
SELECT 
dd.*,
m.BMXBMI as bmi,
d.DIQ010 as diabetes,
mc.MCQ160b as cong_heart_failure,
mc.MCQ160c as cor_heart_disease,
mc.MCQ160e as had_heart_attack,
mc.MCQ160f as had_stroke,
mc.MCQ366b as exercise_deficient
FROM demographic_dietary dd
JOIN body_measures m
ON dd.id = m.SEQN
join diabetes d
ON dd.id = d.SEQN 
join med_conditions mc
ON dd.id = mc.SEQN
WHERE id != 0)
SELECT * from demographic_dietary_health;

-- 15,656 data points
select count(*) as data_points
from combined;
