prompt_generic <- "
Categorize the following passage as either overall 'positive' or 'negative' in its evaluation of incorporating AI tools for public welfare eligibility assessments in the UK in terms of efficiency.

A 'positive' evaluation is the assessment that AI overall has brought about increased work-task output relative to the use of resources.

A 'negative' evaluation is the assessment that AI overall has brought about decreased work-task output relative to the use of resources.

Return only one classification: positive or negative.
"
prompt_operationalized <- "
Categorize the following passage as either overall 'positive' or 'negative' in its evaluation of incorporating AI tools for public welfare eligibility assessments in the UK in terms of efficiency.

A 'positive' evaluation is the assessment that AI overall has brought about increased work-task output relative to the use of resources.

A 'negative' evaluation is the assessment that AI overall has brought about decreased work-task output relative to the use of resources.

Recognize the notion of 'resources' as:
Administrative costs, capacity, cost, costing, costings, costly, data, expense, financial loss, funds, hospital bed, labour, money, public funds, bureaucracy, resource, resources, social security payments, tax, time, timely, weeks, work, workforce, £.

Recognize the notion of 'output' as:
Ability, access, accessible, accurate, achieved, adapting, adequacy, less administration, advancements, affordable, analyses, analysis, less anxiety, assurance, automated output, availability, available, awarded, awareness, fewer barriers, less bias, fewer call volumes, capabilities, care, fewer challenges, city, collaboration, collaborative working, cost-savings, competitiveness, complex, complex data analysis, complexity, fewer concerns, less confusing, connect, coverage, creativity, data, data cleaning, data crunching, data mining, decision making, decisions, delivery, detect fraud, less discrimination, less discriminatory, distribute, less doubt, fewer doubts, ease, effective, effectiveness, efficacy, efficiencies, efficiency, efficiency gains, efficient, efficiently, enabled, enabling, engagement, enhanced, equitable, fewer errors, ethical, expedite, fewer failures, fair, fast pace, faster, less financial detriment, fits, fewer flaws, flexibility, focus, gains, generate, generate insight, generate insights, generating, less harm, health, help, helped, higher value, human involvement, human rights, less humiliating, identification, identify, identifying, identifying patterns, impact, impactful, improve, improving, increasing, individual rights, less inequality, information, innovation, innovative, insights, intelligence, interact, knowledge, fewer limitations, manage, mechanisms, less misallocation, fewer mistakes, objectively, opportunities, optimism, outcomes, participation, patients treated, person centred, potential, less prejudice, presentation, privacy, fewer problems, process, processed, processing, productivity, provision, public engagement, less punitive, recommendations, reliable, research, response, return, rights, rights-respecting, less risk, risk assessment, fewer risks, safe, secure, security, services, less severe effects, saving, savings, time-savings, sharpen, smooth, social interaction, social security, solutions, sovereignty, specialist practice, speed, strategic, strategic input, strategic work, strategy, success, successful, successfully, support, supporting, supremacy, less threat, times, transformative, trust, understand, understanding, use, use of data, valid aims, value, velocity, veracity, less waiting, shorter wait times, well-functioning, less criticism.

Return only one classification: positive or negative.
"
type_answer <- type_object(
  "Binary classification of the passage.",
  label = type_enum(
    c("positive", "negative"),
    "The classification assigned to the passage."
  )
)