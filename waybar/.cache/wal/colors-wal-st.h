const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#090F17", /* black   */
  [1] = "#718BA8", /* red     */
  [2] = "#8B9FBA", /* green   */
  [3] = "#A5B5CC", /* yellow  */
  [4] = "#B9C6D6", /* blue    */
  [5] = "#BACBE1", /* magenta */
  [6] = "#C3CCDD", /* cyan    */
  [7] = "#dee1e9", /* white   */

  /* 8 bright colors */
  [8]  = "#9b9da3",  /* black   */
  [9]  = "#718BA8",  /* red     */
  [10] = "#8B9FBA", /* green   */
  [11] = "#A5B5CC", /* yellow  */
  [12] = "#B9C6D6", /* blue    */
  [13] = "#BACBE1", /* magenta */
  [14] = "#C3CCDD", /* cyan    */
  [15] = "#dee1e9", /* white   */

  /* special colors */
  [256] = "#090F17", /* background */
  [257] = "#dee1e9", /* foreground */
  [258] = "#dee1e9",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
