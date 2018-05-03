# Designing, Running, and Analyzing Experiments

The material from the Coursera course [Designing, Running, and Analyzing Experiments](https://www.coursera.org/learn/designexperiments) by [Jacob O. Wobbrock](https://faculty.washington.edu/wobbrock/).

The course mainly teaches how to analyze experimental data in R using data collected from **HCI experiments**.

The code in this class was in a single file called coursera.R, which I splitted them out to different files for different tests.

## Table of Analysis

### [Tests of Proportions](tests-of-proportions):

<table>
  <thead>
    <tr>
      <th>Samples</th>
      <th>Response Categories</th>
      <th>Asymptotic Tests</th>
      <th>Exact Tests</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>2</td>
      <td>One-sample $\chi^2$ test</td>
      <td>Binomial test</td>
    </tr>
    <tr>
      <td>1</td>
      <td>&gt; 2</td>
      <td>One-sample $\chi^2$ test</td>
      <td>Multinomial test</td>
    </tr>
    <tr>
      <td>&gt; 1</td>
      <td>&gt;= 2</td>
      <td>N-sample $\chi^2$ test</td>
      <td>G-test <br> Fisher’s test</td>
    </tr>
  </tbody>
</table>

### Analyses of Variance (ANOVA):

- B: Between-Subjects
- W: Within-Subjects

<table>
  <thead>
    <tr>
      <th>Factors</th>
      <th>Levels</th>
      <th></th>
      <th>Parametric Tests</th>
      <th>Non-Parametric Tests</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>2</td>
      <td>B</td>
      <td>Independent-samples T-test</td>
      <td>Mann-Whitney U Test</td>
    </tr>
    <tr>
      <td>1</td>
      <td>&gt; 2</td>
      <td>B</td>
      <td>One-way ANOVA</td>
      <td>Kruskal-Wallis Test</td>
    </tr>
    <tr>
      <td>1</td>
      <td>2</td>
      <td>W</td>
      <td>Paired-samples t-test</td>
      <td>Wilcoxon signed-rank test</td>
    </tr>
    <tr>
      <td>1</td>
      <td>&gt; 2</td>
      <td>W</td>
      <td>One-way repeated measures ANOVA</td>
      <td>Friedman test</td>
    </tr>
    <tr>
      <td>&gt; 1</td>
      <td>&gt;= 2</td>
      <td>B</td>
      <td>Factorial ANOVA; Linear Models (LM)</td>
      <td>Aligned Rank Transform (ART) <br> Generalized Linear Models (GLM)</td>
    </tr>
    <tr>
      <td>&gt; 1</td>
      <td>&gt;= 2</td>
      <td>W</td>
      <td>Factorial repeated measures ANOVA <br> Linear Mixed Models (LMM)</td>
      <td>Aligned Rank Transform (ART) <br> Generalized Linear Mixed Models (GLMM)</td>
    </tr>
  </tbody>
</table>

### Other Tests:

<table>
  <tbody>
    <tr>
      <th>Normality</th>
      <td>Shapiro-Wilk</td>
    </tr>
    <tr>
      <th>Poisson distributed variables</th>
      <td>Kolmogorov-Smirnov</td>
    </tr>
    <tr>
      <th>Homogeneity of variance</th>
      <td>Levene's test<br>Frown-Forsythe test</td>
    </tr>
  </tbody>
</table>
