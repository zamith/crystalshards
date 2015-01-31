var gulp = require('gulp');
var sass = require('gulp-ruby-sass');

gulp.task('sass', function () {
  return sass('assets/stylesheets')
    .on('error', function (err) {
      console.error('Error!', err.message);
    })
    .pipe(gulp.dest('dist/css'));
});
